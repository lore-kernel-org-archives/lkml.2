Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777Ab2LGHEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:04:35 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53721 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab2LGHEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:04:33 -0500
MIME-Version: 1.0
In-Reply-To: <1354833773-22845-7-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354833773-22845-1-git-send-email-mark.langsdorf@calxeda.com> <1354833773-22845-7-git-send-email-mark.langsdorf@calxeda.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Thu, 6 Dec 2012 23:04:12 -0800
Message-ID: <CAPtuhTi3Gvb0CQFiAe_bNRQ4k0xfzN9amQvwTeUsaJ7HLJsNHQ@mail.gmail.com>
Subject: Re: [PATCH 6/6 v9] cpufreq, highbank: add support for highbank cpufreq
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 2:42 PM, Mark Langsdorf
<mark.langsdorf@calxeda.com> wrote:
> Highbank processors depend on the external ECME to perform voltage
> management based on a requested frequency. Communication between the
> A9 cores and the ECME happens over the pl320 IPC channel.
>
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: mturquette@linaro.org

Looks good to me.

Reviewed-by: Mike Turquette <mturquette@linaro.org>

Regards,
Mike
