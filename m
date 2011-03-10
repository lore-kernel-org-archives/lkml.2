Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1CJHCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 02:02:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42907 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1CJHCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 02:02:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L/HmTVkulLhWi2uiWC/sCMFJYnn7QGA1MZA4byacgpLTun0xNe9c7KO71q3v+rJUuG
         CHly6CnbAOvAlxD9xMPBthnJWSjGaIffhSyiokKZpMMjVnIc/sUU4WLU1bPrCMOzpEW5
         25SdXE5+hgbWaRnd7EWmeiBqSxvNMl44P2Ys4=
Date: Thu, 10 Mar 2011 08:02:15 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
        johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: some patches for the ptp framework
Message-ID: <20110310070215.GB3195@riccoc20.at.omicron.at>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <20110304062120.GB3824@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304062120.GB3824@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 07:21:20AM +0100, Richard Cochran wrote:
> On Thu, Mar 03, 2011 at 06:26:11PM +0100, Torben Hohn wrote:
> > Richards Patchset didnt apply to tip:core/timer as is.
> > which branch is it based on ?
> 
> I can apply them to
> 
>    db1c1cce4a653dcbe6949c72ae7b9f42cab1b929
> 
> near the head of timers/core in
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> 
> I guess the newer CLOCK_BOOTTIME commits cause a conflict. I will
> rebase once again to fix that.

Torben, I don't understand why you couldn't apply V12 to the
timers/core head. It works fine for me...

Richard


a0e5fef2 ptp: Added a clock driver for the National Semiconductor PHYTER.
a992fe1f ptp: Added a clock driver for the IXP46x.
d57a0b3e ptp: Added a clock that uses the eTSEC found on the MPC85xx.
3f341675 ptp: Added a brand new class driver for ptp clocks.
5cd10e79 hrtimer: Update base[CLOCK_BOOTTIME].offset correctly
7fdd7f89 timers: Export CLOCK_BOOTTIME via the posix timers interface
70a08cca timers: Add CLOCK_BOOTTIME hrtimer base
314ac371 time: Extend get_xtime_and_monotonic_offset() to also return sleep
abb3a4ea time: Introduce get_monotonic_boottime and ktime_get_boottime
e06383db hrtimers: extend hrtimer base code to handle more then 2 clockids
db1c1cce ntp: Remove redundant and incorrect parameter check
22b7fcda mn10300: Switch do_timer() to xtimer_update()
0606f422 posix clocks: Introduce dynamic clocks
