Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1GZNER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:04:17 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:43307 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1GZNEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:04:11 -0400
X-ASG-Debug-ID: 1311685449-03d6a510aa1d7030001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E2EBB46.6060108@fusionio.com>
Date: Tue, 26 Jul 2011 15:04:06 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: block: BUG: using smp_processor_id() in preemptible [00000000]
  code
References: <CACVXFVOYYZt-XfbPx_dEOm9qOAuGqmviH4TdXxg6xTrrB8PaMQ@mail.gmail.com> <4E2E4FF1.1010103@fusionio.com> <CACVXFVPK9B65-McHv9HVsmLNZdwfeLbVgYYagpK-ymEK+hC0RQ@mail.gmail.com>
X-ASG-Orig-Subj: Re: block: BUG: using smp_processor_id() in preemptible [00000000]
  code
In-Reply-To: <CACVXFVPK9B65-McHv9HVsmLNZdwfeLbVgYYagpK-ymEK+hC0RQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1311685449
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70020
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-26 08:22, Ming Lei wrote:
> Hi,
> 
> On Tue, Jul 26, 2011 at 1:26 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 2011-07-26 06:49, Ming Lei wrote:
>>> Hi,
>>>
>>> The bug is observed in -next-20110725, follows the stack trace[1], and
>>> seems the attachment patch can fix the bug.
>>
>> Does this work, too? We don't necessarily need the CPU stable, but
>> spewing debug output isn't very nice.
> 
> This does work, thanks,

Great, thanks for reporting and testing.

-- 
Jens Axboe

