Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab0IPGXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:23:00 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55785 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab0IPGW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:22:59 -0400
Message-ID: <4C91B7C4.6030802@kernel.dk>
Date: Thu, 16 Sep 2010 08:23:00 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix an warning of calling blk_rq_aligned()
References: <20100916133005.56baad7e.sfr@canb.auug.org.au> <1284609357-3076-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1284609357-3076-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-16 05:55, Namhyung Kim wrote:
> 2nd argument of blk_rq_aligned() has changed to 'unsigned long' by
> previous commit 'block: fix an address space warning in blk-map.c'.
> According to that change, its caller has to be modified. This also
> removes address space warnings from sparse.

Thanks, in the future please ensure that you have all{yes,mod}config
tested patches you submit.

-- 
Jens Axboe

