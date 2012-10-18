Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab2JRNbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:31:20 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:38280 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab2JRNbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:31:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,607,1344211200"; 
   d="scan'208";a="15255641"
Date: Thu, 18 Oct 2012 14:30:53 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <ian.campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH 6/6] xen: x86 pvh: use XENMEM_add_to_physmap_range for
 foreign gmfn mappings
In-Reply-To: <1350473532-15863-6-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.DEB.2.02.1210181429360.2689@kaball.uk.xensource.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com> <1350473532-15863-6-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Ian Campbell wrote:
> Squeezing the necessary fields into the existing XENMEM_add_to_physmap
> interface was proving to be a bit tricky so we have decided to go with
> a new interface upstream (the XENMAPSPACE_gmfn_foreign interface using
> XENMEM_add_to_physmap was never committed anywhere). This interface
> also allows for batching which was impossible to support at the same
> time as foreign mfns in the old interface.
> 
> This reverts the relevant parts of "PVH: basic and header changes,
> elfnote changes, ..." and followups and trivially converts
> pvh_add_to_xen_p2m over.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
