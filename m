Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab1JDTqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:46:42 -0400
Received: from mx.binnacle.cx ([74.95.187.105]:39786 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933210Ab1JDTql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:46:41 -0400
Message-Id: <6.2.5.6.2.20111004154056.03993660@binnacle.cx>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Tue, 04 Oct 2011 15:45:21 -0400
To: Joe Perches <joe@perches.com>, Christoph Lameter <cl@gentwo.org>
From: starlight@binnacle.cx
Subject: Re: big picture UDP/IP performance question re 2.6.18 
  -> 2.6.32
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>
In-Reply-To: <1317757118.3580.24.camel@Joe-Laptop>
References: <6.2.5.6.2.20111003112108.03a83a28@binnacle.cx>
 <alpine.DEB.2.00.1110041358500.12199@router.home>
 <1317757118.3580.24.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 12:38 PM 10/4/2011 -0700, Joe Perches wrote:
>On Tue, 2011-10-04 at 14:16 -0500, Christoph Lameter wrote:
>> On Mon, 3 Oct 2011, starlight@binnacle.cx wrote:
>> > I've come to the conclusion that Eric is right
>> > and the primary issue is an increase in the
>> > cost of scheduler context switches.  Have
>> > been watching this number and it has held
>> > pretty close to 200k/sec under all scenarios
>> > and kernel versions, so it has to be
>> > a longer code-path, bigger cache pressure
>> > or both in the scheduler.  Sadly this makes
>> > newer kernels a no-go for us.
>> We had similar experiences. Basically latency
>> constantly gets screwed up by the new fancy
>> features being added to the scheduler and network
>> subsystem (most notorious is the new "fair"
>> scheduler, 2.6.23 made a big
>> step down).
>
>Idly curious, have you compared bfs performance?
>http://ck.kolivas.org/patches/bfs/bfs-faq.txt

No but it certainly does look very interesting.

Looks like trying it out not much more work than
patching and building a kernel and running the
benchmark.  Will take a look and report back
if I do.  Little busy at present but should
have time in a week or so.

