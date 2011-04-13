Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab1DMUNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:13:41 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37466 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537Ab1DMUNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:13:39 -0400
Message-ID: <4DA603F1.7090901@kernel.dk>
Date: Wed, 13 Apr 2011 22:13:37 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Liu Yuan <namei.unix@gmail.com>
CC: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block, blk-sysfs: Use the variable directly instead of
 a function call
References: <1302706797-15980-1-git-send-email-namei.unix@gmail.com>
In-Reply-To: <1302706797-15980-1-git-send-email-namei.unix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-13 16:59, Liu Yuan wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
> 
> In the function blk_register_queue(), var _dev_ is already assigned by
> disk_to_dev().So use it directly instead of calling disk_to_dev() again.

Indeed it is, thanks, I'll add this.

-- 
Jens Axboe

