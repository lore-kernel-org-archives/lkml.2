Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1KXL7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:59:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:41041 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1KXL7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:59:42 -0500
Message-ID: <4ECE31AA.3020007@kernel.dk>
Date: Thu, 24 Nov 2011 12:59:38 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] mtip32xx: uninitialized variable in mtip_quiesce_io()
References: <20111124114702.GA32522@elgon.mountain>
In-Reply-To: <20111124114702.GA32522@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-24 12:47, Dan Carpenter wrote:
> We recently introduce new continue in the loop which make gcc complain.
> In theory if MTIP_FLAG_SVC_THD_ACTIVE_BIT is set, we could hit continue
> over and over until eventually we time out of the loop.  In that case
> "active" should be set as true, but right now it's uninitialized.

Thanks Dan, applied.

-- 
Jens Axboe

