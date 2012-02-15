Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab2BOCcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 21:32:53 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43726
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932129Ab2BOCcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 21:32:53 -0500
Date: Tue, 14 Feb 2012 21:32:49 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -v2 2/3] xfs: make inode quota check more general
Message-ID: <20120215023249.GB17149@infradead.org>
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
 <20120206125030.12624.95365.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206125030.12624.95365.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 09:50:30PM +0900, Mitsuo Hayasaka wrote:
> The xfs checks quota when reserving disk blocks and inodes. In the block
> reservation, it checks if the total number of blocks including current
> usage and new reservation exceed quota. In the inode reservation,
> it checks using the total number of inodes including only current usage
> without new reservation. However, this inode quota check works well
> since the caller of xfs_trans_dquot() always sets the argument of the
> number of new inode reservation to 1 or 0 and inode is reserved one by
> one in current xfs.
> 
> To make it more general, this patch changes it to the same way as the
> block quota check.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
