Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab2DBH66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 03:58:58 -0400
Received: from mout6.freenet.de ([195.4.92.96]:55069 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab2DBH65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 03:58:57 -0400
Message-ID: <4F795BA8.7020404@01019freenet.de>
Date: Mon, 02 Apr 2012 09:56:24 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: KVM <kvm@vger.kernel.org>,
        Kernel-Mailingliste <linux-kernel@vger.kernel.org>
Subject: AMD iommu: Difference between setting iommu=pt and not setting this
 option
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

please, could somebody explain the difference in behaviour between
setting the boot option iommu=pt and not setting it?

I can see the following differences:

w/ iommu=pt:

[    0.832946] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40
[    0.883983] AMD-Vi: Initialized for Passthrough Mode


w/o iommu=pt:

[    0.834905] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40
[    0.894172] AMD-Vi: Lazy IO/TLB flushing enabled



In both cases, I can pass through a PCIe device but not a PCI device (->
no problem with IRQ-sharing - the PCI device has its own exclusive IRQ).

If I use iommu=pt, the passed PCIe device is broken after the VM has
been shutdown and started again.



Thank you,
kind regards,
Andreas
