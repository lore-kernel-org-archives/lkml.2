Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108Ab2FHK7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 06:59:20 -0400
Received: from mout2.freenet.de ([195.4.92.92]:49515 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab2FHK7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:59:19 -0400
Message-ID: <4FD1DA5B.9040404@01019freenet.de>
Date: Fri, 08 Jun 2012 12:56:27 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120428 Firefox/12.0 SeaMonkey/2.9.1
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Andreas Hartmann <andihartmann@01019freenet.de>, bhelgaas@google.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH] PCI: Add Ralink RT2800 broken INTx masking quirk
References: <20120606212241.6627.98371.stgit@bling.home>    <4FD047A7.6050602@01019freenet.de> <1339088741.26976.19.camel@ul30vt>   <201206072101.q57L1LqG003192@mail.maya.org>  <1339104327.26976.45.camel@ul30vt> <4FD1205D.8070501@01019freenet.de> <1339106941.26976.51.camel@ul30vt> <4FD15BE1.40004@01019freenet.de>
In-Reply-To: <4FD15BE1.40004@01019freenet.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Hartmann wrote:
> Alex Williamson wrote:
[...]
>> I just pushed a vfio-3.4 branch to my tree at
>> git://github.com/awilliam/linux-vfio.git.  Please let me know what you
>> find with this.
> 
> Works fine :-) vfio and fglrx and PCIe passthrough.

I rebuild the vfio patch on base of your vfio-3.4 branch and applied it
with the additional quirks patch to the opensuse kernel 3.4.1 (desktop
flavor). Now it's working fine with opensuse, too (PCIe passthrough, PCI
passthrouh and fglrx with a board with AMD chipset 990X)! There have
been slight differences in the two different ways of creating the
complete patch for 3.4 which raised the problem.

Downside is (as you already mentioned), that a lot of devices have to be
unbind to get it working. Would be great, if this could be optimized :-).

Your vfio-3.4 branch helped me a lot!

BTW:
If anybody is interested, I could attach a complete vfio patch for 3.4.



Thanks for your great support and patience,
Andreas
