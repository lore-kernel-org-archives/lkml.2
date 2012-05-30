Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2E3S4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:56:52 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:60122 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab2E3S4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:56:50 -0400
X-ASG-Debug-ID: 1338404209-03d6a5031027110001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FC66D3D.6080509@fusionio.com>
Date: Wed, 30 May 2012 20:55:57 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Block driver bits for 3.5
References: <4FC6189B.9080909@fusionio.com> <1338402812.2760.413.camel@edumazet-glaptop>
X-ASG-Orig-Subj: Re: [GIT PULL] Block driver bits for 3.5
In-Reply-To: <1338402812.2760.413.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1338404209
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.98462
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 08:33 PM, Eric Dumazet wrote:
> On Wed, 2012-05-30 at 14:54 +0200, Jens Axboe wrote:
>> Hi Linus,
>>
>> On top of the for-3.5/core pull request, here are the driver related
>> changes for 3.5. It contains:
> 
> Hi Jens
> 
> Not sure if this is related, but latest Linus tree cannot boot anymore
> here...
> 
> BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]

Hrmpf, can you attach your .config?

-- 
Jens Axboe

