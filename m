Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab2EATDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:03:50 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:59613 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab2EATDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:03:49 -0400
X-ASG-Debug-ID: 1335899028-0421b5151418b50001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FA03391.9010308@fusionio.com>
Date: Tue, 1 May 2012 21:03:45 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be initialized
 to one
References: <1335873936.16988.148.camel@lappy> <20120501161729.GV26595@google.com> <4FA0253F.4000302@fusionio.com> <20120501180906.GX26595@google.com> <4FA028EE.7020208@fusionio.com> <x49wr4vlpn8.fsf@segfault.boston.devel.redhat.com> <4FA02D71.3060001@fusionio.com> <x49obq7lorr.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be initialized
 to one
In-Reply-To: <x49obq7lorr.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1335899028
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.95712
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-01 20:50, Jeff Moyer wrote:
> Jens Axboe <jaxboe@fusionio.com> writes:
> 
>> On 2012-05-01 20:31, Jeff Moyer wrote:
>>> Jens Axboe <jaxboe@fusionio.com> writes:
>>> I know of one project: the venerable dump/restore utility uses CLONE_IO.
>>
>> Thanks Jeff, now I remember the specifics of what we tested. IIRC, we
>> also did numbers back then comparing the coop merging vs specifically
>> using CLONE_IO.
> 
> Maybe?  I picked through some old emails but couldn't find that exact
> comparison.  It would have been a smart thing to do, though!

It might have been in a bugzilla thing, unfortunately. But yes, it'd be
the smart thing to do, hence I was pretty sure that you did it!

-- 
Jens Axboe

