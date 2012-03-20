Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2CTX5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:57:17 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:44830 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab2CTX44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:56:56 -0400
From: Kevin Hilman <khilman@ti.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Robert Lee <rob.lee@linaro.org>, len.brown@intel.com,
        akpm@linux-foundation.org, rjw@sisk.pl, robherring2@gmail.com,
        Baohua.Song@csr.com, amit.kucheria@linaro.org, nicolas.ferre@atmel.com,
        linux@maxim.org.za, kgene.kim@samsung.com, amit.kachhap@linaro.org,
        magnus.damm@gmail.com, nsekhar@ti.com, daniel.lezcano@linaro.org,
        mturquette@linaro.org, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        deepthi@linux.vnet.ibm.com, broonie@opensource.wolfsonmicro.com,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk,
        jean.pihet@newoldbits.com, venki@google.com, ccross@google.com,
        g.trinabh@gmail.com, kernel@wantstofly.org, lethal@linux-sh.org,
        jon-hunter@ti.com, tony@atomide.com, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v8 0/8] Consolidate cpuidle functionality
Organization: Texas Instruments, Inc.
References: <1332274969-15782-1-git-send-email-rob.lee@linaro.org>
	<201203202158.08042.arnd.bergmann@linaro.org> <873992zy5u.fsf@ti.com>
	<201203202305.37952.arnd.bergmann@linaro.org>
Date: Tue, 20 Mar 2012 16:56:51 -0700
In-Reply-To: <201203202305.37952.arnd.bergmann@linaro.org> (Arnd Bergmann's
	message of "Tue, 20 Mar 2012 23:05:37 +0000")
Message-ID: <87ty1ix1vg.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd.bergmann@linaro.org> writes:

> On Tuesday 20 March 2012, Kevin Hilman wrote:
>> Maybe it's time that drivers/cpuidle gets a maintainer.  With lots of
>> discussions of scheduler changes that affect load estimation, I suspect
>> we're all going to have a bit of CPUidle work to do in the
>> not-so-distant future.
>
> Hmm, according to the script, you are the maintainer ;-)

doh, I knew I should've kept quiet :/

> $ scripts/get_maintainer.pl -f drivers/cpuidle/cpuidle.c
> Kevin Hilman <khilman@ti.com> (commit_signer:8/10=80%)
> Len Brown <len.brown@intel.com> (commit_signer:7/10=70%)
> Trinabh Gupta <g.trinabh@gmail.com> (commit_signer:4/10=40%)
> Arjan van de Ven <arjan@linux.intel.com> (commit_signer:4/10=40%)
> Deepthi Dharwar <deepthi@linux.vnet.ibm.com> (commit_signer:4/10=40%)
>
> While I realize that the get_maintainers.pl is not the final word,
> you could be the acting cpuidle maintainer for this merge window
> and send the pull request.

Not exactly the outcome I was hoping for (I have enough stuff to look
after at the moment.) 

However, if you think it would help and won't be seen as a take over
attempt (I don't want to maintain CPUidle), I can possibly do it for
this merge window.  

Before doing that though, I'll need give this series a final once over
before I'm willing to send a potentially flame-attracting pull request.

Kevin


