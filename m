Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1HUShS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 14:37:18 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:42382 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1HUShQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 14:37:16 -0400
X-ASG-Debug-ID: 1313951834-01de28461705b00001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E515057.7040802@fusionio.com>
Date: Sun, 21 Aug 2011 20:37:11 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block bits for 3.1-rc
References: <4E4E6238.3080808@fusionio.com> <20110820174137.GA27243@infradead.org> <4E5146C1.508@fusionio.com> <20110821181935.GA28979@infradead.org>
X-ASG-Orig-Subj: Re: [GIT PULL] block bits for 3.1-rc
In-Reply-To: <20110821181935.GA28979@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313951834
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.72428
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-21 20:19, Christoph Hellwig wrote:
> On Sun, Aug 21, 2011 at 07:56:17PM +0200, Jens Axboe wrote:
>> The discussion was on lkml, as Mike points out. But yes, short time to
>> react. Since I can't easily cater to both cases right now, how about we
>> add a temporary second meta flag that is only used for tracing?
>>
>>         REQ_META        = (__REQ_META | __REQ_META_TRACE),
>>         RET_META_TRACE  = __REQ_META_TRACE,
>>
>> You get the idea. Not super pretty, but it should solve the immediate
>> issue.
> 
> I'd do it the other way around and add a new REQ_META_BOOST flag to
> the old callers.  I'll cook up a patch on the airport / on my flight
> if you want.

That would work fine as well, please do cook up the patch if you have
flight time anyway :-)

-- 
Jens Axboe

