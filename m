Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784Ab2JXNeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:34:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53649 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab2JXNep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <1351079900-32236-4-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-4-git-send-email-hongbo.zhang@linaro.com>
Date: Wed, 24 Oct 2012 19:04:44 +0530
Message-ID: <CAKohpomygrbhNMJ5+P6DnppBTOSXB8GFeQsbjkUZ61Ou6bzaPQ@mail.gmail.com>
Subject: Re: [PATCH V2 3/6] Thermal: fix bug of counting cpu frequencies.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2012 17:28, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>
> In the while loop for counting cpu frequencies, if table[i].frequency equals
> CPUFREQ_ENTRY_INVALID, index i won't be increased, so this leads to an endless
> loop, what's more the index i cannot be referred as cpu frequencies number if
> there is CPUFREQ_ENTRY_INVALID case.
>
> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>

Good one.

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
