Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab2J2LyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:54:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46629 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab2J2LyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:54:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomygrbhNMJ5+P6DnppBTOSXB8GFeQsbjkUZ61Ou6bzaPQ@mail.gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-4-git-send-email-hongbo.zhang@linaro.com>
	<CAKohpomygrbhNMJ5+P6DnppBTOSXB8GFeQsbjkUZ61Ou6bzaPQ@mail.gmail.com>
Date: Mon, 29 Oct 2012 17:24:10 +0530
Message-ID: <CAK44p21JTq79FmxF3k28ZvWRaVaqdMpbSuaO9srGFOw3oiofrg@mail.gmail.com>
Subject: Re: [PATCH V2 3/6] Thermal: fix bug of counting cpu frequencies.
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Hongbo Zhang <hongbo.zhang@linaro.org>, Zhang Rui <rui.zhang@intel.com>
Cc: linaro-kernel@lists.linaro.org, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, "hongbo.zhang" <hongbo.zhang@linaro.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2012 19:04, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 24 October 2012 17:28, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
>> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>>
>> In the while loop for counting cpu frequencies, if table[i].frequency equals
>> CPUFREQ_ENTRY_INVALID, index i won't be increased, so this leads to an endless
>> loop, what's more the index i cannot be referred as cpu frequencies number if
>> there is CPUFREQ_ENTRY_INVALID case.
>>
>> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
>
> Good one.
>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Changes looks fine. Adding thermal maintainer(Rui Zhang) in the mail list.
Reviewed-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>

Thanks,
Amit Daniel
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
