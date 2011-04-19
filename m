Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1DSLvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:51:10 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42154 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab1DSLvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:51:09 -0400
Message-ID: <4DAD772F.3060906@kernel.dk>
Date: Tue, 19 Apr 2011 13:51:11 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Liu Yuan <namei.unix@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block, blk-sysfs: Fix an err return path in blk_register_queue()
References: <1303201038-11222-1-git-send-email-namei.unix@gmail.com>
In-Reply-To: <1303201038-11222-1-git-send-email-namei.unix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-19 10:17, Liu Yuan wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
> 
> We do not call blk_trace_remove_sysfs() in err return path
> if kobject_add() fails. This path fixes it.

Thanks, applied.

-- 
Jens Axboe

