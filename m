Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1AXTJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:09:59 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:50853 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab1AXTJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:09:58 -0500
X-ASG-Debug-ID: 1295896197-01de280c5331600001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D3DCE81.9080701@fusionio.com>
Date: Mon, 24 Jan 2011 20:09:53 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] block: kill request allocation batching
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-7-git-send-email-jaxboe@fusionio.com> <20110122093133.GA6749@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 06/10] block: kill request allocation batching
In-Reply-To: <20110122093133.GA6749@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1295896197
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.53327
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-22 10:31, Christoph Hellwig wrote:
> On Sat, Jan 22, 2011 at 01:17:25AM +0000, Jens Axboe wrote:
>> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> 
> A little more explanation of this surely wouldn't hurt.

That goes for pretty much all of the patches in this series. I'll update
them and add a proper description.

-- 
Jens Axboe

