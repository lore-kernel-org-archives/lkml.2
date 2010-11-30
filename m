Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0K3TxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:53:17 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54637 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab0K3TxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:53:15 -0500
Message-ID: <4CF5562A.6040001@kernel.dk>
Date: Tue, 30 Nov 2010 20:53:14 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: Get rid of on_st flag
References: <4CF4B8BB.7050106@cn.fujitsu.com>
In-Reply-To: <4CF4B8BB.7050106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-30 09:41, Gui Jianfeng wrote:
> It's able to check whether a CFQ group on a service tree by
> checking "cfqg->rb_node". There's no need to maintain an
> extra flag here.

Thanks, applied.

-- 
Jens Axboe

