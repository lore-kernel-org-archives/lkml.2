Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab2DPT0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:26:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54410 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2DPT0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:26:05 -0400
Message-ID: <4F8C7247.3060702@kernel.dk>
Date: Mon, 16 Apr 2012 21:25:59 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH] mtip32xx: release the semaphore on an error path
References: <4F8C71FD.70204@micron.com>
In-Reply-To: <4F8C71FD.70204@micron.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-16 21:24, Asai Thambi S P wrote:
> Release the semaphore in an error path in mtip_hw_get_scatterlist(). This
> fixes the smatch warning inconsistent returns.

Thanks Asai, and Dan for the report. Applied.

-- 
Jens Axboe

