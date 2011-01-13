Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab1AMTZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:25:53 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:40626 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1AMTZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:25:49 -0500
X-ASG-Debug-ID: 1294946747-71f7b70a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D2F51B5.6060105@fusionio.com>
Date: Thu, 13 Jan 2011 20:25:41 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephen Hemminger <shemminger@vyatta.com>,
        Pekka Enberg <penberg@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block driver updates for 2.6.38
References: <4D2F03F2.4000707@fusionio.com> <AANLkTi=t9FQaUhnXCk51bjZO82F8OGDDd9H5HyMPRPQd@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] block driver updates for 2.6.38
In-Reply-To: <AANLkTi=t9FQaUhnXCk51bjZO82F8OGDDd9H5HyMPRPQd@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1294946747
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.52283
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-13 20:00, Linus Torvalds wrote:
> On Thu, Jan 13, 2011 at 5:53 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> Pekka Enberg (1):
>>      floppy: replace NO_GEOM macro with a function
> 
> Hmm. When I see work on floppy.c, I end up wondering what happened to
> the work by Stephen to use a single threaded workqueue?
> 
> That was reported to fix a KVM oops at some point to to avoiding the
> whole race between interrupts/workqueues, but it seems to have dropped
> off everybody's radar. I don't think anybody ever tested it on real
> hardware, but I'm still wondering..

Not sure, I don't recall seeing it.

-- 
Jens Axboe

