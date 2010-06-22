Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab0FVVYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0FVVYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:24:40 -0400
Subject: Re: [PATCH] Xen-SWIOTBL v0.8.3 used for Xen PCI pass through for
 PV guests.
From: Alex Williamson <alex.williamson@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 15:23:25 -0600
Message-ID: <1277241805.4669.691.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 15:42 -0400, Konrad Rzeszutek Wilk wrote:
> These nineteen patches lay the groundwork for Xen Paravirtualized (PV)
> domains to access PCI pass-through devices. These patches utilize the
> SWIOTLB library modifications (http://lkml.org/lkml/2010/6/4/272).
> 
> The end user of this is the Xen PCI frontend and Xen PCI [1] which
> require a DMA API "backend" that understands Xen's MMU. This allows the
> PV domains to use PCI devices.

Hi Konrad,

Sorry if I missed it, but I didn't see any mention or apparent
requirement of a hardware iommu in xen for this code.  Is that true?  If
so, is there anything to stop a PV guest with ownership of a DMA capable
PCI device from reading all sorts of memory that the domain wouldn't
otherwise have access to?  I was under the impression that the old PCI
front/back for PV guests was mainly an interesting hack with limited
applications due to security.  Thanks,

Alex

