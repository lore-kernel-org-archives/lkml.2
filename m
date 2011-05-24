Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab1EXSnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:43:03 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:57964 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214Ab1EXSnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:43:01 -0400
X-ASG-Debug-ID: 1306262579-01de28096b62890001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDBFC30.6030201@fusionio.com>
Date: Tue, 24 May 2011 20:42:56 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Start of removal of legacy parallel interfaces for
  3.0
References: <4DDBF40E.7020003@fusionio.com> <BANLkTi=sYVpvEwShbhC65qfaA0Jt3rEjsQ@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] Start of removal of legacy parallel interfaces for
  3.0
In-Reply-To: <BANLkTi=sYVpvEwShbhC65qfaA0Jt3rEjsQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306262579
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-24 20:37, Linus Torvalds wrote:
> On Tue, May 24, 2011 at 11:08 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> With the 3.0 kernel approaching, now is a great time to get rid of some
>> legacy bagage. And what better part to start with than the old IDE code.
>> Parallel interfaces are so 1990's, we can't be seen with those on a
>> fancy new kernel version.
> 
> No.
> 
> Guys. Really.
> 
> Any version numbering change is *not* an excuse to drop any old stuff,
> or do anything new and exciting.

Boy, you guys sure are humorless. I would've thought the reference to
killing SCSI next would be a good clue.

So we can't kill x86 32-bit either?

-- 
Jens Axboe

