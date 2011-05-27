Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1E0NNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:13:22 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56865
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab1E0NNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:13:21 -0400
Date: Fri, 27 May 2011 09:12:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] blktrace: treat flush as barrier
Message-ID: <20110527131237.GA27647@infradead.org>
References: <1306501883-23498-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306501883-23498-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:11:22PM +0900, Namhyung Kim wrote:
> Since BARRIER requests have been converted to FLUSH/FUA, it would be
> better for blktrace to recognize FLUSH requests as BARRIER for the
> backward-compatibility IMHO.

I'd rather see new flags for them.  F and U maybe?

