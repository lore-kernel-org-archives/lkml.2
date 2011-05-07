Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1EGB2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:28:34 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60546 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab1EGB2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:28:33 -0400
Message-ID: <4DC4A03F.2040603@kernel.dk>
Date: Fri, 06 May 2011 19:28:31 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Remove extra discard_alignment from hd_struct.
References: <1303287455-3796-1-git-send-email-tm@tao.ma>
In-Reply-To: <1303287455-3796-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-20 02:17, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Currently, hd_struct.discard_alignment is only used when we
> show /sys/block/sdx/sdx/discard_alignment. So remove it and
> calculate when it is asked to show.

Thanks, applied.

-- 
Jens Axboe

