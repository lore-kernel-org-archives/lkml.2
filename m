Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1AJTcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:32:08 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:39947 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab1AJTb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:31:56 -0500
X-ASG-Debug-ID: 1294687915-178953bc0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D2B5EA5.9030900@fusionio.com>
Date: Mon, 10 Jan 2011 20:31:49 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "ltuikov@yahoo.com" <ltuikov@yahoo.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [BLOCK] Allow tag 0 to be generated
References: <835205.47474.qm@web31809.mail.mud.yahoo.com>
X-ASG-Orig-Subj: Re: [PATCH] [BLOCK] Allow tag 0 to be generated
In-Reply-To: <835205.47474.qm@web31809.mail.mud.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1294687915
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4882 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.52000
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-10 20:27, Luben Tuikov wrote:
> --- On Mon, 1/10/11, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> That commit isn't a valid sha in my tree. What commit
>> do you mean?
>>>
>>>> skipped tag 0 by virtue of setting last_tag to
>>>> 0. This commit sets it to -1, in order to start
>>>> and loop over from 0, thus generating tags
>>>> [0,max_tag-1], instead of [1,max_tag-1].
>>>
>>> Irregardless, patch looks good. That's definitely a
>> bug. Thanks!
>>
>> But not in my kernel, what tree are you looking at? I don't
>> remember
>> seeing any tag patches, and they should be in my tree if
>> there are.
> 
> It applies on top of this patch:
> 
> From 67869fb9fdfa04503b250d59e086c15f1698aea0 Mon Sep 17 00:00:00 2001

Ah I see. It doesn't make sense to mention shas in your own tree in
commit messages for patches you send, as they will not be valid unless
your tree is actually pulled from.

And since this patch is not in any tree, and at least I didn't agree
with it, then you should post your updated fixed patch instead of
sending a patch against a broken patch.

-- 
Jens Axboe

