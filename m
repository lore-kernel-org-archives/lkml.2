Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab1DRJh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:37:27 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:37408 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab1DRJhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:37:23 -0400
X-ASG-Debug-ID: 1303119441-01de284cf815c230001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAC0653.80000@fusionio.com>
Date: Mon, 18 Apr 2011 11:37:23 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: block workqueues
References: <20110418092141.GB32013@infradead.org>
X-ASG-Orig-Subj: Re: block workqueues
In-Reply-To: <20110418092141.GB32013@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303119441
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61203
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-18 11:21, Christoph Hellwig wrote:
> Hi Jens,
> 
> is there any reason that blk_delay_queue queues to the system workqueue and
> not kblockd?

No, it should use kblockd. Fixed up.

-- 
Jens Axboe

