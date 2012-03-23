Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab2CWI7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:59:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:53212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2CWI7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:59:03 -0400
Message-ID: <4F6C3B1F.9090703@kernel.dk>
Date: Fri, 23 Mar 2012 09:58:07 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] block: use caller's GFP flags instead of GFP_KERNEL
References: <20120323083624.GC18239@elgon.mountain>
In-Reply-To: <20120323083624.GC18239@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 09:36 AM, Dan Carpenter wrote:
> We should use the GFP flags that the caller specified instead of picking
> our own.  All the callers specify GFP_KERNEL so this doesn't make a
> difference to how the kernel runs, it's just a cleanup.

Thanks Dan, applied to for-3.4/core

-- 
Jens Axboe

