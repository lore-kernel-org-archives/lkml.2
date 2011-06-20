Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1FTUFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:05:47 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:48475 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1FTUFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:05:44 -0400
X-ASG-Debug-ID: 1308600344-03d6a510a9781e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DFFA814.40006@fusionio.com>
Date: Mon, 20 Jun 2011 22:05:40 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH] cfq: Remove special treatment for metadata rqs.
References: <1308599559-16839-1-git-send-email-teravest@google.com> <4DFFA6B8.50506@fusionio.com> <BANLkTin6yt5PCG1uOamGiGjU++tznQNkAcdTGfNDOhLQvU-1=g@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH] cfq: Remove special treatment for metadata rqs.
In-Reply-To: <BANLkTin6yt5PCG1uOamGiGjU++tznQNkAcdTGfNDOhLQvU-1=g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1308600344
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66631
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-20 22:03, Justin TerAvest wrote:
> On Mon, Jun 20, 2011 at 12:59 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 2011-06-20 21:52, Justin TerAvest wrote:
>>> There is no consistency among filesystems from what bios (or requests)
>>> are marked as being metadata. It's interesting to expose this in traces,
>>> but we shouldn't schedule the requests differently based on whether or
>>> not they're marked as being metadata.
>>
>> Agree, we should kill that. What is this patch against? cfq_choose_req()
>> also has a "choose meta over non-meta" preference.
> 
> This is against for-3.1. Let me know if you want it against something else.

Great, right branch.

> Sorry, I missed the preference in cfq_choose_req, since it changed to
> be clever about bit operations. I'll send a v2 patch that cleans that
> use up as well.

Thanks!

-- 
Jens Axboe

