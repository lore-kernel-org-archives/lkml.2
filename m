Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0DMKCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 06:02:11 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39645 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab0DMKCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:02:09 -0400
Date: Tue, 13 Apr 2010 12:02:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Chad Talbott <ctalbott@google.com>,
       Divyesh Shah <dpshah@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2 V3] [RESEND] io-controller: add per device weight
	rule  support
Message-ID: <20100413100207.GZ27497@kernel.dk>
References: <4BC42475.8080605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC42475.8080605@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13 2010, Gui Jianfeng wrote:
> Hi
> 
> This patchset adds a new interface "weight_device" for blkio controller,
> and has already rebased to block tree for-2.6.35 branch.

Applied

-- 
Jens Axboe

