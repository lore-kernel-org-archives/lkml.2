Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2L3Kjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 05:39:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55171 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2L3Kjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 05:39:52 -0500
Date: Sun, 30 Dec 2012 11:39:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Dmitry E. Oboukhov" <unera@debian.org>,
        kernel list <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.7.1 doesn't go to suspend
Message-ID: <20121230103948.GA8650@amd.pavel.ucw.cz>
References: <20121230090621.GA5756@vdsl.uvw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121230090621.GA5756@vdsl.uvw.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2012-12-30 13:06:21, Dmitry E. Oboukhov wrote:
> Hi, Linux maintainers!
> 
> First of all sorry for my bad English.
> 
> I have Macbook Pro Retina and used Linux-3.7rc7 with the book.
> It worked fine.
> 
> Today I've tried to migrate to 3.7.1 (from debian repo) and found that
> current kernel can't suspend.
> 
> If I call pm-suspend in my shell, my computer doesn't go to suspend
> and dmesg showes the error:
> 
> [ 2512.960666] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37 [snd_hda_intel] returns -11
> 
> 
> 3.7rc7 worked fine.
> 
> 
> In attaches You can find some /proc/* files

You may want to rmmod snd_hda_inte before suspend and see if it helps?

									Pavel



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
