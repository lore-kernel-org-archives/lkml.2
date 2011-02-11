Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab1BKPSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:18:23 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:38565 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab1BKPSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:18:22 -0500
X-ASG-Debug-ID: 1297437502-03d6a50f0954c60001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D555388.9040201@fusionio.com>
Date: Fri, 11 Feb 2011 16:19:36 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: remove obsolete comments for blkdev_issue_zeroout.
References: <1297435386-2914-1-git-send-email-tm@tao.ma>
X-ASG-Orig-Subj: Re: [PATCH] block: remove obsolete comments for blkdev_issue_zeroout.
In-Reply-To: <1297435386-2914-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1297437502
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.55031
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-11 15:43, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> barrier is already removed, so remove the obsolete comments
> in blkdev_issue_zeroout.

Thanks, I'll add this to the queue.

-- 
Jens Axboe

