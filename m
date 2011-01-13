Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab1AMTb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:31:56 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:40667 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab1AMTbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:31:53 -0500
X-ASG-Debug-ID: 1294947112-71f7b71b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D2F5324.7070305@fusionio.com>
Date: Thu, 13 Jan 2011 20:31:48 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Alasdair G Kergon <agk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block bits for 2.6.38
References: <4D2F03A7.2030809@fusionio.com> <20110113192152.GA18217@agk-dp.fab.redhat.com>
X-ASG-Orig-Subj: Re: [GIT PULL] core block bits for 2.6.38
In-Reply-To: <20110113192152.GA18217@agk-dp.fab.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1294947112
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

On 2011-01-13 20:21, Alasdair G Kergon wrote:
> On Thu, Jan 13, 2011 at 02:52:39PM +0100, Jens Axboe wrote:
>> Below are the core block bits for 2.6.38.
>  
>> Tejun Heo (17):
>>       block: simplify holder symlink handling
> 
> This one was found to be causing problems in linux-next yesterday: 
>   http://permalink.gmane.org/gmane.linux.file-systems/50132
> 
> Perhaps you could drop it for now until a solution's found?

Oh, nobody told me about that. I have an addon, give me a few minutes to
push it out.

-- 
Jens Axboe

