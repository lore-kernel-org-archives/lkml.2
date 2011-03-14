Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1CNIUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 04:20:08 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:37675 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1CNIUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 04:20:04 -0400
X-ASG-Debug-ID: 1300090801-01de284cf859280001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D7DCFAD.3000704@fusionio.com>
Date: Mon, 14 Mar 2011 09:19:57 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Czerner <lczerner@redhat.com>
Subject: Re: [GIT PULL] Single important block patch for 2.6.38
References: <4D7A33FF.80509@fusionio.com> <AANLkTi=NAeBWE28Vygx5Qf+OYgMW2Js180fptQnbbXmw@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] Single important block patch for 2.6.38
In-Reply-To: <AANLkTi=NAeBWE28Vygx5Qf+OYgMW2Js180fptQnbbXmw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300090801
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57852
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-13 23:51, Linus Torvalds wrote:
> On Fri, Mar 11, 2011 at 6:38 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> This fixes a regression introduced early in the 2.6.38 series, where
>> blkdev_issue_zeroout() has a nasty race that causes a panic. Thanks to
>> Lukas Czerner for finding and fixing this one. Please pull!
> 
> What about the "Null pointer OOPS in sync_inodes_sb" issue due to the
> broken sb->s_bdi setting to NULL?

Sent something out to George to test, hopefully we can close this one
for 2.6.38 in a simple fashion.

-- 
Jens Axboe

