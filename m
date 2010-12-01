Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab0LAOnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:43:43 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:45853 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab0LAOnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:43:42 -0500
X-ASG-Debug-ID: 1291214620-6da359770001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CF65F19.3000201@fusionio.com>
Date: Wed, 1 Dec 2010 15:43:37 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "jmarchan@redhat.com" <jmarchan@redhat.com>
Subject: Re: [PATCH 0/2] blk-throttle: Couple of small fixes
References: <1291136157-2732-1-git-send-email-vgoyal@redhat.com> <4CF5557E.70600@fusionio.com> <20101201142921.GA4672@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 0/2] blk-throttle: Couple of small fixes
In-Reply-To: <20101201142921.GA4672@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1291214620
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.5000 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.48174
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-01 15:29, Vivek Goyal wrote:
> On Tue, Nov 30, 2010 at 08:50:22PM +0100, Jens Axboe wrote:
>> On 2010-11-30 17:55, Vivek Goyal wrote:
>>> Hi Jens,
>>>
>>> During some testing and discussions with Oleg, two bugs were noticed with
>>> block throttle code. Please find attached the fixes. These are small fixes
>>> and I did not notice any side affects during my testing.
>>
>> I never seemed to receive 2/2, did it get lost?
>>
> 
> Hi Jens,
> 
> I do see 2/2 on lkml and you are in "to" list.
> 
> https://lkml.org/lkml/2010/11/30/212
> 
> Not sure what happened. I will bounce the mail to you again.

Thanks, that is odd. I got the bounce.

-- 
Jens Axboe

