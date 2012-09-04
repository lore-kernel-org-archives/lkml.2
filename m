Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab2IDK5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 06:57:25 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44746
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761Ab2IDK5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 06:57:24 -0400
Date: Tue, 4 Sep 2012 06:57:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Li Wang <liwang@nudt.edu.cn>
Cc: viro@zeniv.linux.org.uk, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] VFS: File System Mount Wide O_DIRECT Support
Message-ID: <20120904105714.GA31020@infradead.org>
References: <000001cd8a86$89df83b0$9d9e8b10$@edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cd8a86$89df83b0$9d9e8b10$@edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 06:17:47PM +0800, Li Wang wrote:
> For file system created on file-backed loop device, there will be two-levels of 
> page cache present, which typically doubles the memory consumption. 

And the right fix is to not use buffer I/O on the backing file instead
of hacks like this.

