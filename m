Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935526Ab2JYJz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:55:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:48830 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934884Ab2JYJzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:55:55 -0400
Message-ID: <50890CA0.1070608@kernel.dk>
Date: Thu, 25 Oct 2012 11:55:44 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] block: move blk_queue_bypass_{start,end} to include/linux/blkdev.h
References: <50890931.3050906@ce.jp.nec.com>
In-Reply-To: <50890931.3050906@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-25 11:41, Jun'ichi Nomura wrote:
> [PATCH] block: move blk_queue_bypass_{start,end} to include/linux/blkdev.h
> 
> dm wants to use those functions to control the bypass status of
> half-initialized device.
> 
> This patch is a preparation for:
>   [PATCH] dm: stay in blk_queue_bypass until queue becomes initialized

Applied. The previous state of private blk.h declaration but the symbols
exported was wrong, too.

-- 
Jens Axboe

