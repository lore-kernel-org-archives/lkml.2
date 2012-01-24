Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2AXSCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:02:22 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49332
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645Ab2AXSCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:02:21 -0500
Date: Tue, 24 Jan 2012 13:02:15 -0500
From: Christoph Hellwig <hch@infradead.org>
To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc: xfs@oss.sgi.com, elder@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: remove unecessary AIL push wakeups
Message-ID: <20120124180215.GC23671@infradead.org>
References: <20120113013028.6802d878@ustc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113013028.6802d878@ustc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 01:30:28AM +0800, JiSheng Zhang wrote:
> 
> In commit 0030807c66("xfs: revert to using a kthread for AIL pushing"),
> AIL pushing is revert back to use a kthread. But unfortunately, it
> introduced a regression: there are unnecessary AIL push wakeups during
> idle, ~20 wakeups/s. This change remove the wakeups by reverting a bit
> more: set "tout" value as zero during idle.
> 
> Signed-off-by: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>

Looks fine, although I'm a bit worried that I don't have the setup to
reproduce the issue that the patch addressed any more and we might
regress here.

