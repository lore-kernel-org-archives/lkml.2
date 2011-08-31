Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1HaISh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 04:18:37 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:36965 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1HaISe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 04:18:34 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: greg@kroah.com, stable@kernel.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com
In-Reply-To: <20110822152354.GA24763@dumpdata.com>
References: <20110822152354.GA24763@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 09:18:18 +0100
Message-ID: <1314778698.28989.28.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: Please back-port git commit
 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9 and
 89153b5cae9f40c224a5d321665a97bf14220c2c to 3.0.x
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-22 at 11:23 -0400, Konrad Rzeszutek Wilk wrote:
> Hey Greg,
> 
> I've two patches that are in Linus's upstream kernel, but I neglected to
> put the stable@kernel.org on them (duh!). Both Fedora and Ubuntu are carrying
> those two patches - but it would be nice if other distros got them.
> 
> The two patches are:
> 
> commit 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9
> Author: Stefan Bader <stefan.bader@canonical.com>
> Date:   Thu Jul 14 15:30:22 2011 +0200
> 
>     xen-blkfront: Drop name and minor adjustments for emulated scsi devices
> 
> commit 89153b5cae9f40c224a5d321665a97bf14220c2c
> Author: Stefan Bader <stefan.bader@canonical.com>
> Date:   Thu Jul 14 15:30:37 2011 +0200
> 
>     xen-blkfront: Fix one off warning about name clash
> 
> Please back-port them to 3.0.x kernel. Thank 

On a related note having this in stable/longterm (including 2.6.32.y)
seems like a good idea? (it was already in the 3.0 baseline)

commit 4352b47ab7918108b389a48d2163c9a4c2aaf139
Author: Marek Marczykowski <marmarek@mimuw.edu.pl>
Date:   Tue May 3 12:04:52 2011 -0400

    xen-blkfront: fix data size for xenbus_gather in blkfront_connect
    
    barrier variable is int, not long. This overflow caused another variable
    override: "err" (in PV code) and "binfo" (in xenlinux code -
    drivers/xen/blkfront/blkfront.c). The later caused incorrect device
    flags (RO/removable etc).
    
    Signed-off-by: Marek Marczykowski <marmarek@mimuw.edu.pl>
    Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
    [v1: Changed title]
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Ian.
-- 
Ian Campbell
Current Noise: Pestilence - Subordinate To The Domination

It's raisins that make Post Raisin Bran so raisiny ...

