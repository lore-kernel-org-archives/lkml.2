Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2DARum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:50:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40680 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2DARuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:50:03 -0400
Message-ID: <1333302596.32308.28.camel@clam>
Subject: [ANNOUNCE] Petitboot now available as Debian package
From: Geoff Levand <geoff@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Date: Sun, 01 Apr 2012 10:49:56 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Just for anyone interested, there is now a packaging of Petitboot in Debian that
allows you to install it as a kind of reboot utility.  This is mainly intended
for developers who want a convenient way of either rebooting to kernels served
from remote machines or want a way to select a kernel and/or boot options from a
menu without going through a cold reboot to get to a first stage bootloader
menu.

The Debian package should also work on other recent Debian derivatives, I've
tested it on Ubuntu 12.04.  I've recently added a grub2 config file parser to
petitboot, so it can now parse kboot, yaboot and grub2 config files.  This makes
it easier to use on system that have yaboot or grub2 as their primary bootloader.

Comments, usage reports, etc. would be greatly appreciated.


About Petitboot:

Petitboot is a platform independent bootloader based on the Linux kexec warm
reboot mechanism. Petitboot supports loading kernel and initrd image files from
any mountable Linux device, plus can load image files from the network using
TFTP, NFS, HTTP, HTTPS, and SCP. Petitboot can boot any operating system
supported by kexec.  More info about petitboot is available at its home page:

  http://www.kernel.org/pub/linux/kernel/people/geoff/petitboot/petitboot.html

Some info about the Debian package can be found through my QA page:

  http://qa.debian.org/developer.php?login=geoff%40infradead.org

-Geoff


