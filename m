Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1DUDhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 23:37:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab1DUDhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 23:37:52 -0400
Date: Wed, 20 Apr 2011 23:37:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v3] xen block backend.
Message-ID: <20110421033735.GA11501@infradead.org>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should sit in userspace.  And last time was discussed the issue
Stefano said the qemu Xen disk backend is just as fast as this kernel
code.  And that's with an not even very optimized codebase yet.

So clear NAK for adding all this mess to the kernel.
