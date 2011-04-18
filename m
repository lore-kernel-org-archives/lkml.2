Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1DRJi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:38:26 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:38785 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1DRJiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:38:22 -0400
X-ASG-Debug-ID: 1303119501-03d6a55d38c9100001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAC068E.1040701@fusionio.com>
Date: Mon, 18 Apr 2011 11:38:22 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: add blk_run_queue_async
References: <20110418092647.GB3837@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH] block: add blk_run_queue_async
In-Reply-To: <20110418092647.GB3837@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303119501
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61202
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-18 11:26, Christoph Hellwig wrote:
> Instead of overloading __blk_run_queue to force an offload to kblockd
> add a new blk_run_queue_async helper to do it explicitly.  I've kept
> the blk_queue_stopped check for now, but I suspect it's not needed
> as the check we do when the workqueue items runs should be enough.

Thanks, that's a lot prettier.

-- 
Jens Axboe

