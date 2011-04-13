Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab1DMRfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:35:38 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:39506 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab1DMRfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:35:37 -0400
X-ASG-Debug-ID: 1302716135-01de284cf813fad0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA5DEE1.9070803@fusionio.com>
Date: Wed, 13 Apr 2011 19:35:29 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, NeilBrown <neilb@suse.de>,
        Dave Chinner <david@fromorbit.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <20110411223623.4278fad1@notabene.brown> <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org> <4DA40F0E.1070903@fusionio.com> <20110412122248.GC31057@dastard> <4DA4456F.3070301@fusionio.com> <20110412124134.GD31057@dastard> <4DA44C86.3090305@fusionio.com> <20110412133117.GE31057@dastard> <4DA45790.2010109@fusionio.com> <20110412143452.GH31057@dastard> <20110413070827.11b2a71d@notabene.brown> <BANLkTikBEJa7bJJoLFU7NoiEgOjVHVG08A@mail.gmail.com> <1302693122.2035.20.camel@laptop> <4DA587AF.2040308@fusionio.com> <BANLkTimTGGJjXGX96LqP0YL4dcdGONFyhA@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <BANLkTimTGGJjXGX96LqP0YL4dcdGONFyhA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302716135
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60755
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-13 17:13, Linus Torvalds wrote:
> On Wed, Apr 13, 2011 at 4:23 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> Linus, I've got a few other things queued up in the area, I'll add this
>> and send them off soon. Or feel free to add this one yourself, since you
>> already did it.
> 
> Ok, I committed it with Peter's and your acks.

Great, thanks.

> And if you already put it in your git tree too, git will merge it.

I did not, I had a feeling you'd merge this one.

-- 
Jens Axboe

