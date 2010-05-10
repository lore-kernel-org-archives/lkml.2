Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0EJL4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:56:47 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58855 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0EJL4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:56:43 -0400
Date: Mon, 10 May 2010 13:56:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Block: Check major number before allocate the buffer
	in register_blkdev()
Message-ID: <20100510115642.GB27497@kernel.dk>
References: <20100510061602.GB2858@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510061602.GB2858@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10 2010, wzt.wzt@gmail.com wrote:
> Check major number before allocate the buffer, if the major number is not exist,
> and the register_blkdev() called many times, kmalloc()/kfree() will be no need 
> to invoked many times. So check the major number before use kmalloc() to allocate
> the buffer will be better.

This would generally be sound advice for performance oriented code, but
I can't see it making any difference here.

-- 
Jens Axboe

