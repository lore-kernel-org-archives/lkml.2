Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1FJIyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:54:46 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:35529 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505Ab1FJIyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:54:45 -0400
X-Greylist: delayed 79433 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jun 2011 04:54:45 EDT
Message-ID: <4DF1DBB2.4040501@stericsson.com>
Date: Fri, 10 Jun 2011 10:54:10 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: john stultz <johnstul@us.ibm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 0/3] clocksource: add db8500 PRCMU timer
References: <1307007271-1004-1-git-send-email-mattias.wallin@stericsson.com> <20110602094622.GS3660@n2100.arm.linux.org.uk> <4DE7637B.3060901@stericsson.com> <20110602110137.GU3660@n2100.arm.linux.org.uk> <4DE77D9A.6090301@stericsson.com> <4DE788B2.5060308@ti.com> <1307040455.11492.52.camel@work-vm> <4DEF7CA1.8080809@stericsson.com> <20110609215939.GI24424@n2100.arm.linux.org.uk>
In-Reply-To: <20110609215939.GI24424@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 11:59 PM, Russell King - ARM Linux wrote:
> No - I'd like you to check whether the patch I sent fixes your
> sched_clock problem across suspend/resume so that we can get that sorted
> for everyone, instead of coming up with platform specific fixes.  Then
> we can work out how to hook that into cpuidle so that it works properly
> there.

Ahh, I see your plan. I was focused on the cpuidle problem and your 
patch only addressed suspend/resume.
Anyway, now that I understand more what you are after I'll have a look 
at it and come back to you.
