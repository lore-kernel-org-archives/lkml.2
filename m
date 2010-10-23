Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab0JWTId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:08:33 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:55550 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab0JWTIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:08:30 -0400
X-ASG-Debug-ID: 1287860909-08b79c3a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC332A9.7020001@fusionio.com>
Date: Sat, 23 Oct 2010 21:08:25 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] block: remove REQ_HARDBARRIER
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com> <20101023165924.GA1395@lst.de>
X-ASG-Orig-Subj: Re: [PATCH] block: remove REQ_HARDBARRIER
In-Reply-To: <20101023165924.GA1395@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1287860909
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44533
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-23 18:59, Christoph Hellwig wrote:
>  - blktrace handling of barriers - removed.  Someone who knows blktrace
>    better should add support for REQ_FLUSH and REQ_FUA, though.

I'll update blktrace to be current there, btw.

-- 
Jens Axboe

