Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1FMIqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 04:46:06 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:59875 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab1FMIqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 04:46:03 -0400
X-ASG-Debug-ID: 1307954762-03d6a510a8230e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DF5CE47.3070600@fusionio.com>
Date: Mon, 13 Jun 2011 10:45:59 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Wanlong Gao <wanlong.gao@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block:fix the comment error in blkdev.h
References: <1307804235-5658-1-git-send-email-wanlong.gao@gmail.com>
X-ASG-Orig-Subj: Re: [PATCH] block:fix the comment error in blkdev.h
In-Reply-To: <1307804235-5658-1-git-send-email-wanlong.gao@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1307954762
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65980
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-11 16:57, Wanlong Gao wrote:
> There is not a function rq_init but blk_rq_init in block/blk-core.c.

Thanks, applied.

-- 
Jens Axboe

