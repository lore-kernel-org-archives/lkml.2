Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1E2HtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 03:49:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34894 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab1E2HtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 03:49:13 -0400
Date: Sun, 29 May 2011 09:49:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Markus <M4rkusXXL@web.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39 hangs on boot
Message-ID: <20110529074908.GA3762@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Markus <M4rkusXXL@web.de>,
	lkml <linux-kernel@vger.kernel.org>
References: <201105282235.24530.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201105282235.24530.M4rkusXXL@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 10:35:24PM +0200, Markus wrote:
> Hi!
> 
> I tried the vanilla 2.6.39 today, but it doesnt even boot. The last 
> lines I see are:
> Refined TSC clocksource calibration: 3210.779 MHz.
> Switching to clocksource tsc
> 
> After that nothing more happens. After a minute I rebooted into a 2.6.38 
> kernel, it worked:
> $ dmesg | grep clocksource
> Switching to clocksource hpet
> Refined TSC clocksource calibration: 3210.778 MHz.
> Switching to clocksource tsc
> 
> 
> Issue known? Any patch/workaround? How could I help?

Please send /proc/cpuinfo, .config and dmesg of the successful boot.

Thanks.

-- 
Regards/Gruss,
    Boris.
