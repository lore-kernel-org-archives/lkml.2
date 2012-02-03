Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2BCWIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:08:17 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33570 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179Ab2BCWIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:08:15 -0500
X-Sasl-enc: v4WO905D+QaRY7wt9imQcouOZA7p8O4SpAcXITwgQ3kB 1328306894
Date: Fri, 3 Feb 2012 14:07:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [0/1] 3.2.5-stable review
Message-ID: <20120203220739.GA3660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.5 release.

It's a bit different from other stable review cycles in that it only has
one patch.

It's a fix to decrease power consumption on a wide range of different
machines.  I wanted to make this a separate release to make it easier
for people to test it out in a simple way.  This patch has been shipping
in the Fedora kernels for a while now, so I'm pretty confident about it,
but I'm doing it this way just to be sure.

Please let me know if anyone has any problems with it as soon as
possible.

Responses should be made by Monday, February 6, 2012, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                 |    4 +-
 drivers/acpi/pci_root.c  |    7 +++++
 drivers/pci/pci-acpi.c   |    1 -
 drivers/pci/pcie/aspm.c  |   58 +++++++++++++++++++++++++++++----------------
 include/linux/pci-aspm.h |    4 +-
 5 files changed, 48 insertions(+), 26 deletions(-)
