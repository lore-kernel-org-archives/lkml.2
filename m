Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1IQNxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 09:53:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42379
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab1IQNxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 09:53:48 -0400
Date: Sat, 17 Sep 2011 09:53:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xip: export xip_file_fault
Message-ID: <20110917135346.GA31551@infradead.org>
References: <4E749003.30909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E749003.30909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 02:18:11PM +0200, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> There aren't sufficient sync points for a fs for xip operations. In 
> particular for the mmap case. It can be not sufficient to lock/unlock 
> to do some operation inside get_xip_mem callback. For xip_file_read 
> it's really easy to write a fs specific wrapper, xip_file_write hold 
> i_mutex so no problem. With this patch it's possible to reuse the
> generic xip_file_fault, using a wrapper function in a fs, without to
> reinvent the wheel.

As usual please send patches to add exports only while adding callers
for it.

