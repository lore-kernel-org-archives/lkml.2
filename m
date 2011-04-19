Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1DSRiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:38:23 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39314 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab1DSRiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:38:23 -0400
Message-ID: <4DADC88F.2060704@kernel.dk>
Date: Tue, 19 Apr 2011 19:38:23 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix new kernel-doc warning in blk-core
References: <20110419083806.708d94be.randy.dunlap@oracle.com>
In-Reply-To: <20110419083806.708d94be.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-19 17:38, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix new blk-core.c kernel-doc warning:
> 
> Warning(block/blk-core.c:302): Excess function parameter 'force_kblockd' description in '__blk_run_queue'

Thanks Randy, but I already queued up such a fix earlier today.

-- 
Jens Axboe

