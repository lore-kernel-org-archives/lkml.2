Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1LGGXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:23:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:47006 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1LGGXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:23:03 -0500
Message-ID: <1323238949.660.65.camel@pasglop>
Subject: Re: RFC: Device isolation infrastructure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>, joerg.roedel@amd.com,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com
Date: Wed, 07 Dec 2011 17:22:29 +1100
In-Reply-To: <20111207035816.GC7631@truffala.fritz.box>
References: <20111207035816.GC7631@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 14:58 +1100, David Gibson wrote:
> Alex Williamson recently posted some patches adding a new hook to
> iommu_ops to identify groups of devices which cannot reliably be
> distinguished by the iommu, and therefore can only safely be assigned
> as a unit to a guest or userspace driver.

Please ignore the numeros typos, David is typing all of that with a
broken hand in a cast... 

Cheers,
Ben.

