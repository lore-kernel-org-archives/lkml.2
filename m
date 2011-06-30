Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1F3LnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:43:10 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50505
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483Ab1F3Lm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:42:59 -0400
Date: Thu, 30 Jun 2011 07:42:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Christoph Hellwig <hch@tuxera.com>, Anton Salikhmetov <alexo@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, roman@ardistech.com,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH 2/2] hfsplus: Fix double iput of the same inode in
 hfsplus_fill_super()
Message-ID: <20110630114254.GB9597@infradead.org>
References: <1308863702-30859-1-git-send-email-khoroshilov@ispras.ru>
 <1308863702-30859-2-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308863702-30859-2-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 01:15:02AM +0400, Alexey Khoroshilov wrote:
> There is a misprint in resource deallocation code on error path in
> hfsplus_fill_super(): the sbi->alloc_file inode is iput twice,
> while the root inode in not iput at all.

Thanks, I'll put it in.

