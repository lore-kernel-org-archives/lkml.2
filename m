Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1AMTcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:32:41 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:40677 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab1AMTck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:32:40 -0500
X-ASG-Debug-ID: 1294947158-71f7b71d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D2F5353.3000400@fusionio.com>
Date: Thu, 13 Jan 2011 20:32:35 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alasdair G Kergon <agk@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block bits for 2.6.38
References: <4D2F03A7.2030809@fusionio.com> <20110113192152.GA18217@agk-dp.fab.redhat.com> <AANLkTin8icx0cir8czy9snZ0wg=QovJ4HSZru4jYUoea@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] core block bits for 2.6.38
In-Reply-To: <AANLkTin8icx0cir8czy9snZ0wg=QovJ4HSZru4jYUoea@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1294947158
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.52285
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-13 20:26, Linus Torvalds wrote:
> On Thu, Jan 13, 2011 at 11:21 AM, Alasdair G Kergon <agk@redhat.com> wrote:
>>
>> This one was found to be causing problems in linux-next yesterday:
>>  http://permalink.gmane.org/gmane.linux.file-systems/50132
>>
>> Perhaps you could drop it for now until a solution's found?
> 
> Sadly I already merged.
> 
> And yes, I get the warning too. Tejun?

I see Tejun already posted a fix, but Milan says it does not work.
Tejun, any  updates?


-- 
Jens Axboe

