Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1FMSTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:19:55 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39551 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab1FMSTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:19:55 -0400
Message-ID: <4DF654C6.4070701@kernel.dk>
Date: Mon, 13 Jun 2011 20:19:50 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-throttle: Make total_nr_queued unsigned
References: <f5e32f63cf03e8fb6f6b9c8e66a6ac0c4d5c3d45.1307980331.git.joe@perches.com>
In-Reply-To: <f5e32f63cf03e8fb6f6b9c8e66a6ac0c4d5c3d45.1307980331.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-13 17:54, Joe Perches wrote:
> cc: Vivek Goyal <vgoyal@redhat.com>
> 
> The total of two unsigned values should also be unsigned.
> 
> Update throtl_log output to unsigned.
> Update total_nr_queued test to non-zero to be the
> same as the other total_nr_queued tests.

Thanks, I pulled this into for-3.1/core with the ack from Vivek.

-- 
Jens Axboe

