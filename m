Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1BXAIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:08:30 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:58986 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1BXAI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:08:29 -0500
X-Greylist: delayed 1528 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Feb 2011 19:08:28 EST
Date: Thu, 24 Feb 2011 00:42:58 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Cc: nikola.ciprich@linuxbox.cz
Subject: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't boot
Message-ID: <20110223234258.GA29548@nik-comp.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4625972 records (last update: 20110223)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Avi et al,
seems like I've hit regression in 2.6.37:
32bit SMP centos guest stopped booting, they just hang during initrd phase. (haven't tried
different distros)
UP guest are OK.
when I (forcibly) compiled kvm-kmod-2.6.36.2 and used it in 2.6.37, even
the SMP guests boot fine.
does somebody have a tip on where the problem could be, or should I bisect this?
I tried on 2 different machines, host is x86_64, qemu-kvm 0.13.0, 0.14.0.
If I shall provide more information (or bisect), please let me know.
cheers!
nik


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
