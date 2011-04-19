Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1DSRnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:43:39 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:33549 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab1DSRni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:43:38 -0400
X-ASG-Debug-ID: 1303235017-03d6a5652cdd500001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DADC9C8.4050303@fusionio.com>
Date: Tue, 19 Apr 2011 19:43:36 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bart Van Assche <bvanassche@acm.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>,
        David Dillow <dave@thedillows.org>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera> <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com> <4DAC2429.5000105@fusionio.com> <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com> <4DAC82E6.3020809@fusionio.com> <BANLkTimaekpwmK+z=ePE+XSP6GUteidwfw@mail.gmail.com> <4DAD5156.2050300@fusionio.com> <4DAD6EF2.5070405@fusionio.com> <BANLkTimLOgY1opmAt+rxmYtLa-6adL98wg@mail.gmail.com> <BANLkTikzRE7sA8_NNgVUpOqR_zGtw+YUvQ@mail.gmail.com>
X-ASG-Orig-Subj: Re: [Bug #32982] Kernel locks up a few minutes after boot
In-Reply-To: <BANLkTikzRE7sA8_NNgVUpOqR_zGtw+YUvQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303235017
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61329
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-19 18:32, Linus Torvalds wrote:
> On Tue, Apr 19, 2011 at 9:13 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> The same test with an initiator running 2.6.39-rc4 +
>> git://git.kernel.dk/linux-2.6-block.git for-linus + the above patch
>> yields about 155.000 IOPS on my test setup, or the same performance as
>> with 2.6.38.3. I'm running the above patch through an I/O stress test
>> now.
> 
> Goodie. So not only does that patch get back the 11%, it removes the
> crazy QUEUE_FLAG_REENTER flag that was broken to begin with. AND it
> removes a number of complicated lines.
> 
> Halleluja.

Indeed, coming your way soonish.

-- 
Jens Axboe

