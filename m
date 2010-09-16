Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab0IPSvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:51:07 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:36625 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab0IPSvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:51:05 -0400
X-Greylist: delayed 1098 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2010 14:51:05 EDT
X-ASG-Debug-ID: 1284661963-08b707560001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C9262C4.9050006@fusionio.com>
Date: Thu, 16 Sep 2010 20:32:36 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        "codalist@coda.cs.cmu.edu" <codalist@TELEMANN.coda.cs.cmu.edu>,
        "autofs@linux.kernel.org" <autofs@linux.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Petr Vandrovec <vandrove@vc.cvut.cz>, Anders Larsen <al@alarsen.net>,
        Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Samuel Ortiz <samuel@sortiz.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: Remaining BKL users, what to do
References: <201009161632.59210.arnd@arndb.de> <1284648549.23787.26.camel@gandalf.stny.rr.com>
X-ASG-Orig-Subj: Re: Remaining BKL users, what to do
In-Reply-To: <1284648549.23787.26.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1284661963
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.41014
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-16 16:49, Steven Rostedt wrote:
> On Thu, 2010-09-16 at 16:32 +0200, Arnd Bergmann wrote:
>> The big kernel lock is gone from almost all code in linux-next, this is
>> the status of what I think will happen to the remaining users:
> 
>> kernel/trace/blktrace.c:
>> 	Should be easy. Ingo? Steven?
>>
> 
> Jens,
> 
> Git blame shows this to be your code (copied from block/blktrace.c from
> years past).
> 
> Is the lock_kernel() needed here? (although Arnd did add it in 62c2a7d9)

It isn't, it can be removed.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
