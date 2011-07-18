Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1GRR1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 13:27:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58418
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163Ab1GRR1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 13:27:53 -0400
Date: Mon, 18 Jul 2011 13:27:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH] fs:update the NOTE of the file_operations structure
Message-ID: <20110718172744.GA15785@infradead.org>
References: <1311009790-10312-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311009790-10312-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /*
>   * NOTE:
>   * all file operations except setlease can be called without
> - * the big kernel lock held in all filesystems.
> + * the special spin_lock file_lock_lock held in all filesystems.
>   */
>  struct file_operations {
>  	struct module *owner;

I'd just remove the comment entirely.
