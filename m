Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935150Ab2JXPML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:12:11 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55364
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935005Ab2JXPMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:12:09 -0400
Date: Wed, 24 Oct 2012 11:12:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/21] procfs: drop vmtruncate
Message-ID: <20121024151208.GB24318@infradead.org>
References: <5082965D.3070307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5082965D.3070307@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 02:17:33PM +0200, Marco Stornelli wrote:
> Removed vmtruncate
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

As Al pointed out we probably shouldn't even allow truncate on procfs.
Can look into refusing it instead, please?

