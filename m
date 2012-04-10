Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2DJQMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:12:36 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:32018 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2DJQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:12:35 -0400
X-IronPort-AV: E=Sophos;i="4.75,399,1330905600"; 
   d="scan'208";a="11861929"
Date: Tue, 10 Apr 2012 17:16:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jan Beulich <JBeulich@suse.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Jens Axboe <axboe@kernel.dk>,
        xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-blkfront: properly name all devices
In-Reply-To: <4F8475A7020000780007D139@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.00.1204101710010.15151@kaball-desktop>
References: <4F7DD852020000780007CC2A@nat28.tlf.novell.com> <alpine.DEB.2.00.1204101645000.15151@kaball-desktop> <4F8475A7020000780007D139@nat28.tlf.novell.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012, Jan Beulich wrote:
> >>> On 10.04.12 at 17:50, Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Would you be up for writing a couple of lines under Documentation to
> > clearly state what device names are going to be given by blkfront in
> > correspondence to vdev numbers?
> 
> I'm not really eager to, and in order to be useful, this should imo include
> the compat mapping, and specifically for this I'd prefer someone (you?)
> who was involved in putting this together to do eventual write-ups for it.
 
What compat mappings?
Do you mean the non-extended vdev names?

If you refer to the behavior of older kernels, I don't think it matters
here: the document is supposed to specify what the corresponding kernel
codebase does about xen block names, not what past kernels used to do.
Also, the Xen side vdev policy doesn't matter that much, because we
already clarified that it is up to the guest to choose whatever name it
wants for a given vdev.

In any case if you don't feel like writing it up, I'll do it.
