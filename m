Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189Ab0DEFgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 01:36:08 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46963 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750886Ab0DEFgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 01:36:00 -0400
Date: Mon, 5 Apr 2010 07:36:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.34-rc3: Can't insmod after make, because versions now differ?!
Message-ID: <20100405053628.GA12217@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I guess version check is needed, but this is excessive:

Apr  5 07:33:16 amd kernel: udlfb: version magic
'2.6.34-rc3-00345-ge8240f9-dirty SMP mod_unload CORE2 ' should be
'2.6.34-rc3-00344-g548fc0a-dirty SMP mod_unload CORE2 '

Yes, I played with git and recompiled my kernel in order to get new
module version, but... not even insmod -f works.

Having to reboot every time I recompile the module or play with git
makes modules useless for development :-(.
								Pavel
 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
