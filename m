Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab1CXSgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:36:42 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:57174 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328Ab1CXSgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:36:41 -0400
X-ASG-Debug-ID: 1300991799-01de284cf8b61a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8B8F34.5000203@fusionio.com>
Date: Thu, 24 Mar 2011 19:36:36 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <4D8B4A89.80608@fusionio.com> <20110324183019.GA1676@gentoo.trippels.de>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <20110324183019.GA1676@gentoo.trippels.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300991799
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58854
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-24 19:30, Markus Trippelsdorf wrote:
> On 2011.03.24 at 14:43 +0100, Jens Axboe wrote:
>>
>> This is the main pull request for the block IO layer and friends for
>> 2.6.39.
> 
> This merge results in an early oops on my system (amd64, xfs).
> See the attached photo.
> 

Auch. Can you ensure that you have CONFIG_DEBUGINFO=y in your .config
and then do:

$ gdb vmlinux
...
l *cfq_insert_request+0x32

and send that output?

-- 
Jens Axboe

