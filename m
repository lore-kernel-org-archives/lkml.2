Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab0K3TxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:53:06 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54628 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756443Ab0K3TxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:53:05 -0500
Message-ID: <4CF5561F.6010902@kernel.dk>
Date: Tue, 30 Nov 2010 20:53:03 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: Get rid of st->active
References: <4CF4B7C6.7080600@cn.fujitsu.com>
In-Reply-To: <4CF4B7C6.7080600@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-30 09:37, Gui Jianfeng wrote:
> When a cfq group is running, it won't be dequeued from service tree, so
> there's no need to store the active one in st->active. Just gid rid of it.

Thanks Gui, applied.

-- 
Jens Axboe

