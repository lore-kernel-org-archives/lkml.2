Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1HWMw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:52:28 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:36712 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab1HWMwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:52:18 -0400
X-ASG-Debug-ID: 1314103937-03d6a50f481b5b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E53A27E.9040007@fusionio.com>
Date: Tue, 23 Aug 2011 14:52:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Namhyung Kim <namhyung@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] block: separate priority boosting from REQ_META
References: <4E4E6238.3080808@fusionio.com> <20110820174137.GA27243@infradead.org> <4E5146C1.508@fusionio.com> <20110821181935.GA28979@infradead.org> <4E515057.7040802@fusionio.com> <20110822165221.GB7257@infradead.org> <87r54cg9vn.fsf@gmail.com> <20110823100940.GA4903@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 2/2 v2] block: separate priority boosting from REQ_META
In-Reply-To: <20110823100940.GA4903@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1314103937
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.72595
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-23 12:09, Christoph Hellwig wrote:
> Add a new REQ_PRIO to let requests preempt others in the cfq I/O schedule,
> and lave REQ_META purely for marking requests as metadata in blktrace.
> 
> All existing callers of REQ_META except for XFS are updated to also
> set REQ_PRIO for now.

Thanks, applied 1/2 and this one to for-linus.

-- 
Jens Axboe

