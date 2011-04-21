Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1DUIGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:06:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab1DUIGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:06:40 -0400
Date: Thu, 21 Apr 2011 04:06:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad@kernel.org" <konrad@kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH v3] xen block backend.
Message-ID: <20110421080638.GA10630@infradead.org>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
 <20110421033735.GA11501@infradead.org>
 <1303370925.5997.322.camel@zakaz.uk.xensource.com>
 <1303373003.5997.337.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303373003.5997.337.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 09:03:23AM +0100, Ian Campbell wrote:
> BTW about the only nice property blktap has as it currently stands over
> this plan is that it exports an actual block device from vhd, qcow etc
> files (in some sense blktap is a loopback driver for complex disk image
> file formats). It turns out to occasionally be quite useful to be able
> to mount such files, even on non-virtualisation systems (in its current
> incarnation blktap has no dependency on Xen).

You can already do that using qemu-nbd today.  In most cases the image
format support in qemu is much better than in the various Xen trees
anyway, with vhd beeing the only one that looks potentially better in
Xen.

