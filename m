Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1JYJtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:49:14 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1204 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab1JYJtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:49:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Oct 2011 11:49:06 +0200
From: Mark Hurenkamp <mark.hurenkamp@xs4all.nl>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>
Subject: Fwd: [Bug 860175] Re: pci passthrough of =?UTF-8?Q?snd=5Fhda=5Fin?=
 =?UTF-8?Q?tel=20or=20via=20usb=20to=20oneiric=20hvm=20breaks=20xen=20pvop?=
 =?UTF-8?Q?s=20drivers?=
Message-ID: <47a7e2cca77c8cc5f749f171070fcb82@xs4all.nl>
User-Agent: XS4ALL Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


While upgrading my xen host & guests to oneiric, i seem to have 
stumbled over a
problem in the xen subsystem for recent (3.0 & 3.1) kernels. What i 
notice is that
the pvops disk driver fails during boot, when i use pci passthrough on 
some
(not all) devices, i suspect what works is PCIe, and what doesn't work 
is PCI.
Disabling acpi, pci passthrough of some devices, or the xen pvops block 
driver
seems to solve the problem.

For more detailed information see 
https://bugs.launchpad.net/bugs/860175

I would have liked to submit this pr to bugzilla.kernel.org as 
requested by the
ubuntu team, but that site does not seem to be online, hence i'm 
reporting this
to linux-kernel and xen-devel mailinglists instead.

If there's anything more i can do to help track this problem down, do 
let me know.


Warm regards,
Mark.


-------- Original Message --------
Subject: [Bug 860175] Re: pci passthrough of snd_hda_intel or via usb 
to oneiric hvm breaks xen pvops drivers
Date: Mon, 24 Oct 2011 23:01:00 -0000
 From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: mark.hurenkamp@xs4all.nl
Reply-To: Bug 860175 <860175@bugs.launchpad.net>

This issue appears to be an upstream bug, since you tested the latest
upstream kernel.  Would it be possible for you to open an upstream bug
report at bugzilla.kernel.org [1]?  That will allow the upstream
Developers to examine the issue, and may provide a quicker resolution 
to
the bug.

If you are comfortable with opening a bug upstream, It would be great 
if
you can report back the upstream bug number in this bug report.  That
will allow us to link this bug to the upstream report.

[1] https://wiki.ubuntu.com/Bugs/Upstream/kernel

** Changed in: linux (Ubuntu)
        Status: Confirmed => Triaged

-- 
You received this bug notification because you are subscribed to the 
bug
report.
https://bugs.launchpad.net/bugs/860175

Title:
   pci passthrough of snd_hda_intel or via usb to oneiric hvm breaks xen
   pvops drivers

To manage notifications about this bug go to:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/860175/+subscriptions


