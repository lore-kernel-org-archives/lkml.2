Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2IIKoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 06:44:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55892 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2IIKoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 06:44:11 -0400
Message-ID: <504C72F4.2050805@kernel.dk>
Date: Sun, 09 Sep 2012 12:44:04 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jaehoon Chung <jh80.chung@samsung.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] block: remove the duplicated setting for congestion_threshold
References: <504074AD.2010309@samsung.com>
In-Reply-To: <504074AD.2010309@samsung.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-08-31 10:24, Jaehoon Chung wrote:
> Before call the blk_queue_congestion_threshold(),
> the blk_queue_congestion_threshold() is already called at blk_queue_make_rquest().
> Because this code is the duplicated, it has removed.

So it is, good catch. Applied.

-- 
Jens Axboe

