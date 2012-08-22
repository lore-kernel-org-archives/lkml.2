Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2HVPDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:03:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:33354 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab2HVPCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:02:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336348800"; 
   d="scan'208";a="14129486"
Date: Wed, 22 Aug 2012 16:01:56 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/events: fix unmask_evtchn for PV on HVM
 guests
In-Reply-To: <20120822140315.GC30964@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208221601080.15568@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com> <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1206221722040.27860@kaball.uk.xensource.com> <20120709141915.GB9580@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207131821250.23783@kaball.uk.xensource.com> <20120716151441.GD552@phenom.dumpdata.com> <alpine.DEB.2.02.1207181851010.23783@kaball.uk.xensource.com> <alpine.DEB.2.02.1208221217290.15568@kaball.uk.xensource.com>
 <20120822140315.GC30964@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Wed, Aug 22, 2012 at 12:20:09PM +0100, Stefano Stabellini wrote:
> > Konrad,
> > I cannot see this patch anywhere in your trees. Did I miss it?
> > Or maybe it just fell through the cracks?
> 
> Fell through the cracks.. Was there a new version of this? Can you
> send me a subset of the patches you want me to pick up?

OK, I'll send out a small patch series based on v3.6-rc2
