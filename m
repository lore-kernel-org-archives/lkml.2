Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab1I2N6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:58:34 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:40794 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab1I2N6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:58:33 -0400
X-IronPort-AV: E=Sophos;i="4.68,461,1312156800"; 
   d="scan'208";a="8131079"
Date: Thu, 29 Sep 2011 14:58:19 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v5 2/2] xen: modify kernel mappings corresponding
 to granted pages
In-Reply-To: <20110929135558.GA31321@phenom.oracle.com>
Message-ID: <alpine.DEB.2.00.1109291458050.3519@kaball-desktop>
References: <alpine.DEB.2.00.1109291148340.3519@kaball-desktop> <1317293876-23891-2-git-send-email-stefano.stabellini@eu.citrix.com> <20110929135558.GA31321@phenom.oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Konrad Rzeszutek Wilk wrote:
> >  /* Xen machine address */
> > @@ -31,8 +32,10 @@ typedef struct xpaddr {
> >  #define INVALID_P2M_ENTRY	(~0UL)
> >  #define FOREIGN_FRAME_BIT	(1UL<<(BITS_PER_LONG-1))
> >  #define IDENTITY_FRAME_BIT	(1UL<<(BITS_PER_LONG-2))
> > +#define GRANT_FRAME_BIT	(1UL<<(BITS_PER_LONG-3))
> 
> I am going to change that to (BITS_PER_LONG-1) as we aren't
> using the P2M. (and add that comment in the file).
> 
> And both patches are now in 3.2 queue.

OK, thanks.
