Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab1DUSg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:36:56 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:58849 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab1DUSgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:36:55 -0400
X-ASG-Debug-ID: 1303411014-03d6a57329f95f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DB07942.20209@fusionio.com>
Date: Thu, 21 Apr 2011 20:36:50 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Michael Guntsche <mike@it-loops.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39 Block layer regression was [Bug] Boot hangs with  2.6.39-rc[123]]
References: <20110415035451@it-loops.com> <BANLkTi=50A4f_d0a0oESd3DMMaK1za5BWg@mail.gmail.com> <20110415042255.GC27928@infradead.org> <4DA7E202.4000307@fusionio.com> <alpine.DEB.2.01.1104211051490.18728@trent.utfs.org> <BANLkTim7SLt6TMqJQw35=tnACax0mE1URA@mail.gmail.com> <4DB077AF.7020909@nerdbynature.de>
X-ASG-Orig-Subj: Re: 2.6.39 Block layer regression was [Bug] Boot hangs with  2.6.39-rc[123]]
In-Reply-To: <4DB077AF.7020909@nerdbynature.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303411014
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61525
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-21 20:30, Christian Kujau wrote:
> Linus Torvalds wrote on 2011-04-21 10:59 :
>> As of right now, all _known_ block bugs should be fixed in the stuff I
>> just pushed out, with the current top-of-tree being the merge of the
>> IDE CD endless loop issue and the NULL ptr oops at elevator change
>> time:
> 
> OK, thanks.
> 
>> That said, that udevd message of yours would imply a full root
>> filesystem, which can cause any amount of issues at boot time..
> 
> My /dev is mounted as udev and is 10MB in size, which is more than
> enough for kernels < 2.6.39. But with 2.6.39 something changed and
> /dev/.udev/queue.bin is growing to 7 MB and more, udevd is spinning like
> crazy and the OOM is reaping processes.
> 
> I'm currently in the middle of a bisect, with 11 steps to go on this
> PowerBook G4 :-\

Please try Linus -git as of now, it could be the excessive udev events
for media change that is causing your problem.

-- 
Jens Axboe

