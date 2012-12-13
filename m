Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2LMC3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:29:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:52968 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab2LMC3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:29:51 -0500
Message-ID: <1355365763.19932.75.camel@pasglop>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Date: Thu, 13 Dec 2012 13:29:23 +1100
In-Reply-To: <1355322875.3224.201.camel@bling.home>
References: <1354636299.1809.431.camel@bling.home>
	 <1354865750-8104-1-git-send-email-aik@ozlabs.ru>
	 <1354901926.3224.96.camel@bling.home> <50C820AF.8050804@ozlabs.ru>
	 <1355322875.3224.201.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 07:34 -0700, Alex Williamson wrote:
> > But what would I put there?... IOMMU ID is more than enough at the moment 
> > and struct iommu_table does not have anything what would have made sense to 
> > show in the sysfs...
> 
> I believe David mentioned that PEs had user visible names.  Perhaps they
> match an enclosure location or something.  Group numbers are rather
> arbitrary and really have no guarantee of persistence.  Thanks, 

I agree. Make up something, for example domain[PE] or something like
that.

Cheers,
Ben.


