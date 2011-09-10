Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab1IJJbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 05:31:35 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54455 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982Ab1IJJbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 05:31:34 -0400
Message-ID: <4E6B2E6E.7010807@ti.com>
Date: Sat, 10 Sep 2011 15:01:26 +0530
From: Santosh <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ccross@android.com, rjw@sisk.pl,
        khilman@ti.com
Subject: Re: [PATCH v2 1/5] cpu_pm: Add cpu power management notifiers
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>	<1315060755-4613-2-git-send-email-santosh.shilimkar@ti.com> <20110909155632.661f5696.akpm@linux-foundation.org>
In-Reply-To: <20110909155632.661f5696.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Saturday 10 September 2011 04:26 AM, Andrew Morton wrote:
> On Sat, 3 Sep 2011 20:09:11 +0530
> Santosh Shilimkar<santosh.shilimkar@ti.com>  wrote:

[...]

>
> Have you identified which indivudual you hope/expect to merge this into
> mainline?
>
> The code is presumably and hopefully applicable to architectures other
> than ARM, yes?  Can you suggest likely candidate architectures so we
> can go off and bug the relevant maintainers to review it?
>
Sorry I missed above question in last email. Am not too sure but any
arch which has CPU local timers, interrupt controller, Floating point
co-processor etc, should be able to make use of it. So it's applicable
to any architecture, but whether they want to use it, i don't know.

As you noticed most of the ARM machine's are adapting to it.
Along with generic patch, there are couple ARM drivers adapting
to make use of it. That was the reason I was pushing this series
via Russell's tree.

Regards
Santosh

