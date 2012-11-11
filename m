Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2KKVBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 16:01:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35819 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2KKVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 16:01:21 -0500
Date: Sun, 11 Nov 2012 22:00:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Drunkard Zhang <gongfan193@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Auto reboot when CPU at full load with X86_ACPI_CPUFREQ
Message-ID: <20121111210053.GA6436@elf.ucw.cz>
References: <CAJiejCRAZjNWGyJipfprHGptR2051Fdqf-10OkO0Yks7C2dQ0A@mail.gmail.com>
 <CAJiejCT8F18fH9yrtTDfHydFi6TDNdDWf8Ny7OATokf7EM-X1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJiejCT8F18fH9yrtTDfHydFi6TDNdDWf8Ny7OATokf7EM-X1g@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'm using Intel Xeon X5570 x2 with Asus Z8PE-D18, and experiencing
> auto reboot when CPU full loaded for minutes, like building kernel
> with "make -j17". After a lot of bisecting of config file, I found the
> option leads to the reboot: X86_ACPI_CPUFREQ, both configed
> X86_ACPI_CPUFREQ as a module or built in will lead to reboot.
> 
> Config file finally bisected appended, config-3.7.0-rc3+-bad is the
> one leads to reboot, config-3.7.0-rc3+-ok works OK. Hardware info also
> appended.
> 
> I think it is a bug, anything I can do? When the bug triggered, the
> screen blanked immediately, any advice for me to debug? Happy to match
> to code :-)
> 
> This bug is CPU specific, with Xeon E5606 or E5620 it's all fine, just
> triggered with Xeon X5570, or maybe all Xeon X serial.
> 
> Tested kernel version: 3.1.x, 3.3.x, 3.5.x, 3.6.x, 3.7*, they are all affected.

What does temperature do during those runs? 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
