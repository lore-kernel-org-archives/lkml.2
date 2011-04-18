Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1DRS27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:28:59 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:40715 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab1DRS24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:28:56 -0400
X-ASG-Debug-ID: 1303151334-01de284cf8160090001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAC82E6.3020809@fusionio.com>
Date: Mon, 18 Apr 2011 20:28:54 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera> <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com> <4DAC2429.5000105@fusionio.com> <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com>
X-ASG-Orig-Subj: Re: [Bug #32982] Kernel locks up a few minutes after boot
In-Reply-To: <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303151334
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61237
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-18 20:21, Bart Van Assche wrote:
> On Mon, Apr 18, 2011 at 1:44 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> Bart, can you try and pull:
>>
>> git://git.kernel.dk/linux-2.6-block.git for-linus
>>
>> into Linus' tree and see if that works? This has, among other things,
>> Neils fixes for MD.
> 
> md seems to work stable with the resulting tree, but it looks there is

OK, that's the most important bit.

> a performance regression in the block layer not related to the md
> issue. If I run a small block IOPS test on a block device created by
> ib_srp (NOOP scheduler) I see about 11% less IOPS than with 2.6.38.3
> (155.000 IOPS with 2.6.38.3 and 140.000 IOPS with 2.6.39-rc3+).

That's not good. What's the test case?

-- 
Jens Axboe

