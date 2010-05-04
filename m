Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab0EDQnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:43:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16894 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759856Ab0EDQnJ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 4 May 2010 12:43:09 -0400
Date: Tue, 4 May 2010 12:41:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es
Cc: linux@eikelenboom.it, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org, alex.williamson@hp.com
Subject: Re: [LKML] [PATCH] swiotlb 0.7: separation of physical and virtual
	address translation.
Message-ID: <20100504164107.GA31445@phenom.dumpdata.com>
References: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4BE04E6A.000A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 04:29:24PM -0400, Konrad Rzeszutek Wilk wrote:
> Fujita-san et al.
> 
> Attached is a set of patches that separate the address translation
> (virt_to_phys, virt_to_bus, etc) from the SWIOTLB library.
> 
> Since the last posting [v6] I've done:
>  - Minimized the list exported functions/variable with a prefix of: "swiotbl_tbl".
>  - Made the usage of 'int dir' to be 'enum dma_data_direction'.

Hey Fujita-san,

I was wondering if you had the opportunity to review the patches?

Cheers,
Konrad
