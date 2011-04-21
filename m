Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1DUIie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:38:34 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:27757 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab1DUIic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:38:32 -0400
X-IronPort-AV: E=Sophos;i="4.64,250,1301875200"; 
   d="scan'208";a="5408556"
Subject: Re: [Xen-devel] Re: [PATCH v3] xen block backend.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad@kernel.org" <konrad@kernel.org>
In-Reply-To: <20110421080638.GA10630@infradead.org>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
	 <20110421033735.GA11501@infradead.org>
	 <1303370925.5997.322.camel@zakaz.uk.xensource.com>
	 <1303373003.5997.337.camel@zakaz.uk.xensource.com>
	 <20110421080638.GA10630@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 21 Apr 2011 09:38:31 +0100
Message-ID: <1303375111.5997.341.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 09:06 +0100, Christoph Hellwig wrote:
> On Thu, Apr 21, 2011 at 09:03:23AM +0100, Ian Campbell wrote:
> > BTW about the only nice property blktap has as it currently stands over
> > this plan is that it exports an actual block device from vhd, qcow etc
> > files (in some sense blktap is a loopback driver for complex disk image
> > file formats). It turns out to occasionally be quite useful to be able
> > to mount such files, even on non-virtualisation systems (in its current
> > incarnation blktap has no dependency on Xen).
> 
> You can already do that using qemu-nbd today.

Good to know, I'd had a vague feeling this was possible but hadn't
looked into how.

> In most cases the image format support in qemu is much better than in the various Xen trees
> anyway, with vhd beeing the only one that looks potentially better in Xen.

That's about what I reckon too.

Ian.

