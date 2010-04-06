Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab0DFHGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 03:06:49 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54032 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757343Ab0DFHGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 03:06:43 -0400
Date: Tue, 6 Apr 2010 09:06:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc3: Can't insmod after make, because versions now
	differ?!
Message-ID: <20100406070641.GA19231@atrey.karlin.mff.cuni.cz>
References: <20100405053628.GA12217@elf.ucw.cz> <201004051724.26225.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004051724.26225.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pavel Machek wrote:
> > Apr  5 07:33:16 amd kernel: udlfb: version magic
> > '2.6.34-rc3-00345-ge8240f9-dirty SMP mod_unload CORE2 ' should be
> > '2.6.34-rc3-00344-g548fc0a-dirty SMP mod_unload CORE2 '
> > 
> > Yes, I played with git and recompiled my kernel in order to get new
> > module version, but... not even insmod -f works.
> > 
> > Having to reboot every time I recompile the module or play with git
> > makes modules useless for development :-(.
> 
> Disable CONFIG_LOCALVERSION_AUTO?

Yes, but... should module version checking be fixed so that it does
not interfere like that?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
