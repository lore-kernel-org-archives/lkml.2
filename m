Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2BQDRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:17:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:49023 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab2BQDRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:17:53 -0500
Message-ID: <1329448660.2892.42.camel@pasglop>
Subject: RE: [PATCH V2 RESEND] fsl-sata: I/O load balancing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Liu Qiang-B32616 <B32616@freescale.com>
Cc: "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 17 Feb 2012 14:17:40 +1100
In-Reply-To: <BCB48C05FCE8BC4D9E61E841ECBE6DB702B97D@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1329284944-17943-1-git-send-email-qiang.liu@freescale.com>
	 <1329439216.2892.36.camel@pasglop>
	 <BCB48C05FCE8BC4D9E61E841ECBE6DB702B97D@039-SN2MPN1-013.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 01:54 +0000, Liu Qiang-B32616 wrote:
> The default will be set in a common interface fsl_sata_set_irq_coalescing when
> initialize the controller. This interface will check the range of intr count
> and ticks and make sure the values are reasonably.

Allright, but the current defaults are basically no coalescing right ?

> It's hard to find a aggressive value to adapt all scenarios, so I use echo to adjust
> the value. I remember P5020 have some performance issue, I will check it.
> BTW, which filesystem do you use? Ext2 is lower than ext4 because metadata is 
> continuously wrote to disk. You can try ext4 or xfs. 

ext3 at the moment, I plan to switch to ext4 when I finish that fsck
pass which is taking hours... I am not aware of the 5020 performance
issues, is this something documented and/or fixable ?

Cheers,
Ben.


