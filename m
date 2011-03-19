Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1CSMyO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 08:54:14 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60901 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1CSMyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 08:54:08 -0400
Message-ID: <4D84A76D.70602@kernel.dk>
Date: Sat, 19 Mar 2011 13:54:05 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: NULL dereference on error path in __blkdev_get()
References: <20110318083723.GE8571@htj.dyndns.org>
In-Reply-To: <20110318083723.GE8571@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-18 09:37, Tejun Heo wrote:
> From: Dan Carpenter <error27@gmail.com>
> 
> "disk" is always NULL when we goto out.  There was a check for this
> before, but it was removed in 69e02c59a7d9 "block: Don't check events
> while open is in progress".

Thanks, applied.

-- 
Jens Axboe
