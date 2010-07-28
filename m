Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0G1Gau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:30:50 -0400
Received: from phil.doycomm.com ([66.219.128.249]:41937 "EHLO phil.doycomm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab0G1Gar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:30:47 -0400
X-Greylist: delayed 3511 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2010 02:30:47 EDT
Subject: Re: Linux 2.6.35-rc6
From: Donald Parsons <dparsons@brightdsl.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 01:32:09 -0400
Message-ID: <1280295129.5113.11.camel@falcon.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This rc6 kernel and rc6-git1 fail to boot with message:

    No root device found
    Boot has failed, sleeping forever.

2.6.34.1 and all previous boot fine.  New kernel made
using usual make oldconfig.  initramfs has all same
ata drivers.  Asus motherboard P5B Deluxe, E6600 CPU.
All kernels since mid-June 2010 have been built with
gcc-4.5.0 and work, but neither 2.6.35-rc6 nor the git1
boot.

I went back to gcc-4.4.4 and compiled tonight's -git3
with same identical result, no boot.

What can be wrong?  I see these modules in 2.6.34.1
with lsmod:

Module        Size  Used by
ata_generic   3427  0 
pata_acpi     3227  0 
pata_jmicron  2547  0 
ahci         35887  4 
libata      157450  4 ata_generic,pata_acpi,pata_jmicron,ahci

and also 2.6.35's too by looking in /lib/modules/...
and I see them in the initramfs.img

Note, 2.6.35-rc6 was first of .35 kernels I tried.

Thanks,
Don

