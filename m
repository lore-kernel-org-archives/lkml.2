Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585Ab1LPTXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:23:30 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37964
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756656Ab1LPTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:23:22 -0500
Date: Fri, 16 Dec 2011 14:23:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Move attribute flags into non __KERNEL__ space
Message-ID: <20111216192320.GA23748@infradead.org>
References: <1324021626-10059-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324021626-10059-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 09:47:06AM +0200, Sasha Levin wrote:
> Attribute flags can be useful in userspace when working with filesystems
> such as 9p.

No, they aren't.  They are kernel internal values and userspace has no
fucking business messing with them.

