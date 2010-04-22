Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0DVK3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:29:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48622 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0DVK3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:29:16 -0400
Date: Thu, 22 Apr 2010 06:29:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dan Carpenter <error27@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] fs/sysv: dereferencing ERR_PTR()
Message-ID: <20100422102914.GB996@infradead.org>
References: <20100421103032.GB29647@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421103032.GB29647@bicker>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 12:30:32PM +0200, Dan Carpenter wrote:
> I moved the dir_put_page() inside the if condition so we don't dereference
> "page", if it's an ERR_PTR().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

