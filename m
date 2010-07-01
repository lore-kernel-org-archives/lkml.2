Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0GAG1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 02:27:14 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56210 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab0GAG1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 02:27:13 -0400
Message-ID: <4C2C353F.1030806@fusionio.com>
Date: Thu, 01 Jul 2010 08:27:11 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fs-writeback: fix kernel-doc warnings
References: <20100630152701.0c476a44.randy.dunlap@oracle.com>
In-Reply-To: <20100630152701.0c476a44.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-01 00:27, Randy Dunlap wrote:
> Fix kernel-doc to match the function's changed args.
> 
> Warning(fs/fs-writeback.c:190): No description found for parameter 'args'
> Warning(fs/fs-writeback.c:190): Excess function parameter 'sb' description in 'bdi_queue_work_onstack'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <jaxboe@fusionio.com>

Applied.

-- 
Jens Axboe

