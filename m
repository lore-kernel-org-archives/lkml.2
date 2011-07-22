Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1GVPGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:06:34 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37461
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754605Ab1GVPGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:06:33 -0400
Date: Fri, 22 Jul 2011 11:06:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] mm/truncate.c: fix build for CONFIG_BLOCK not
 enabled
Message-ID: <20110722150622.GA30317@infradead.org>
References: <20110718203501.232bd176e83ff65f056366e6@canb.auug.org.au>
 <20110718081816.2106117e.rdunlap@xenotime.net>
 <20110718152117.GA8844@infradead.org>
 <20110721135537.dbfea947.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721135537.dbfea947.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 01:55:37PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build error when CONFIG_BLOCK is not enabled by providing a stub
> inode_dio_wait() function.
> 
> mm/truncate.c:612: error: implicit declaration of function 'inode_dio_wait'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Looks good to me, thanks a lot Randy!

