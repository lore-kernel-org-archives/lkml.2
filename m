Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1EYS74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:59:56 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:57869 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab1EYS7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:59:55 -0400
X-ASG-Debug-ID: 1306349994-03d6a50f582bf50001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDD51A6.1030509@fusionio.com>
Date: Wed, 25 May 2011 20:59:50 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
References: <20110519222404.GG12600@redhat.com>			 <20110521210013.GJ2271@linux.vnet.ibm.com>			 <20110523152141.GB4019@redhat.com>			 <20110523153848.GC2310@linux.vnet.ibm.com>		 <1306189249.15900.10.camel@t41.thuisdomein> <4DDB7D36.60905@fusionio.com>	 <1306312155.9059.8.camel@t41.thuisdomein> <4DDCC1E4.706@fusionio.com> <1306344530.21978.5.camel@t41.thuisdomein>
X-ASG-Orig-Subj: Re: Mysterious CFQ crash and RCU
In-Reply-To: <1306344530.21978.5.camel@t41.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306349994
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-25 19:28, Paul Bolle wrote:
> On Wed, 2011-05-25 at 10:46 +0200, Jens Axboe wrote:
>> I don't think we are dealing with bad RCU usage in CFQ. My gut tells me
>> that this is related to the merging of cooperating queues. It fits
>> roughly with the time frame of when this issue started occuring, and
>> some of that reference logic looks fragile/racy.
>>
>> So if you _can_ test a patch easily, please try this one. It'll disable
>> that logic.
> 
> I'm sorry, but with that patch (adapted to out previous discussion, so
> simply returning NULL) applied I still hit the same Oops:

No worries, it's still a data point. Back to the drawing board...

-- 
Jens Axboe

