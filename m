Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0JQF27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 01:28:59 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46057 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750833Ab0JQF26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 01:28:58 -0400
Date: Sat, 16 Oct 2010 15:31:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Man Spaz <man.spaz@ymail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tips on debugging suspend/resume failure
Message-ID: <20101016133105.GB1806@ucw.cz>
References: <103889.39682.qm@web120217.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <103889.39682.qm@web120217.mail.ne1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have a machine x86 arch with no serial port, only console. I have a suspend/resume (mem, not hibernate) problem (not sure which one it is, if something fails on the suspend, or the resume fails - but it does seem to go to sleep) that doesn't suspend nor resume at all, using stock standard x86_64 kernel.
> 
> I compiled everything as a module and removed all unnecessary ones, so I cannot isolate the problem to a specific driver. This very same machine had no problems with <2.6.34.2 kernels.
> 
> But the question remains, how to get debug out? Is there a dmesg buffer that can persist if DRAM is being refreshed perhaps? Is there another way to skin this mongrel, I mean cat?
>

git bisect ?

Also you could try to blink keyboard leds, beep the speaker or debug
using 'hang/reboot' trick.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
