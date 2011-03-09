Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab1CISMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:12:24 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:33518 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab1CISMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:12:23 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297036800"; 
   d="scan'208";a="4704265"
Date: Wed, 9 Mar 2011 18:11:59 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: [PATCH] xen: update mask_rw_pte after kernel page tables init
 changes
In-Reply-To: <20110309175621.GI8049@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1103091804300.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103091429300.2968@kaball-desktop> <20110309174335.GH8049@dumpdata.com> <20110309175621.GI8049@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011, Konrad Rzeszutek Wilk wrote:
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > Also pls apply my SOB to "xen: set max_pfn_mapped to the last pfn mapped"
> > 
> 
> Ooops. Please convert those SOBs to Acked-by.
> 

done, thanks :)
I have put together a branch based on tip/x86/mm with those three
patches applied and your acked-by:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-tip-fixes
