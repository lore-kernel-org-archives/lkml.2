Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab2LNTme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:42:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39439 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2LNTmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:42:33 -0500
Message-ID: <50CB8124.4000100@kernel.dk>
Date: Fri, 14 Dec 2012 20:42:28 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: neilb@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2]block: discard granularity might not be power of 2
References: <20121214031536.GA30345@kernel.org>
In-Reply-To: <20121214031536.GA30345@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-14 04:15, Shaohua Li wrote:
> In MD raid case, discard granularity might not be power of 2, for example, a
> 4-disk raid5 has 3*chunk_size discard granularity. Correct the calculation for
> such cases.

Thanks Shaohua, applied both.

-- 
Jens Axboe

