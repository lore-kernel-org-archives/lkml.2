Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab2BOCdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 21:33:12 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43733
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932151Ab2BOCdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 21:33:09 -0500
Date: Tue, 14 Feb 2012 21:33:06 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -v2 3/3] xfs: cleanup quota check on disk blocks and
 inodes reservations
Message-ID: <20120215023306.GC17149@infradead.org>
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
 <20120206125105.12624.93123.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206125105.12624.93123.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 09:51:05PM +0900, Mitsuo Hayasaka wrote:
> This patch is a cleanup of quota check on disk blocks and inodes
> reservations, and changes it as follows.
> 
> (1) add a total_count variable to store the total number of
>     current usages and new reservations for disk blocks and inodes,
>     respectively.
> 
> (2) make it more readable to check if the local variables softlimit
>     and hardlimit are positive. It has been changed as follows.
> 	    if (softlimit > 0ULL) -> if (softlimit)
> 	    if (hardlimit > 0ULL) -> if (hardlimit)
>     This is because they are defined as xfs_qcnt_t which is unsigned.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
