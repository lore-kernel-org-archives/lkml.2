Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1DUIE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:04:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1DUIEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:04:24 -0400
Date: Thu, 21 Apr 2011 04:04:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad@kernel.org" <konrad@kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH v3] xen block backend.
Message-ID: <20110421080411.GA8969@infradead.org>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
 <20110421033735.GA11501@infradead.org>
 <1303370925.5997.322.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303370925.5997.322.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 08:28:45AM +0100, Ian Campbell wrote:
> On Thu, 2011-04-21 at 04:37 +0100, Christoph Hellwig wrote:
> > This should sit in userspace.  And last time was discussed the issue
> > Stefano said the qemu Xen disk backend is just as fast as this kernel
> > code.  And that's with an not even very optimized codebase yet.
> 
> Stefano was comparing qdisk to blktap. This patch is blkback which is a
> completely in-kernel driver which exports raw block devices to guests,
> e.g. it's very useful in conjunction with LVM, iSCSI, etc. The last
> measurements I heard was that qdisk was around 15% down compared to
> blkback.

Please show real numbers on why adding this to kernel space is required.

