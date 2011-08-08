Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1HHPQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:16:17 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:39305 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab1HHPQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:16:15 -0400
X-ASG-Debug-ID: 1312816573-01de280c1e12bfe0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E3FFDB9.3090805@fusionio.com>
Date: Mon, 8 Aug 2011 17:16:09 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>
Subject: Re: exception in interrupt during elv_completed_request. (3.0)
References: <20110808145826.GA22457@redhat.com> <4E3FFAB0.40205@fusionio.com> <20110808151352.GA24992@redhat.com>
X-ASG-Orig-Subj: Re: exception in interrupt during elv_completed_request. (3.0)
In-Reply-To: <20110808151352.GA24992@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312816573
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.71210
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-08 17:13, Dave Jones wrote:
> On Mon, Aug 08, 2011 at 05:03:12PM +0200, Jens Axboe wrote:
>  > On 2011-08-08 16:58, Dave Jones wrote:
>  > > Jens,
>  > > 
>  > > We got a report of a panic from a user when he plugged in his usb drive,
>  > > https://bugzilla.redhat.com/attachment.cgi?id=517141
>  > > 
>  > > any ideas what happened here ?
>  > 
>  > 2.6.40?
> 
> it's 3.0 in all but name. didn't want to risk breaking dumb userspace
> in an update for older fedora releases.  It does have the
> scsi_dispatch_cmd fix that went into 3.0.1, but otherwise block/
> should be stock 3.0

OK

>  > Looks like the recent SCSI removal oopses, perhaps it happened when he
>  > yanked it instead of directly on insertion?
>  
> sorry my bad, yes, this was on device removal.
> 
> according to the user, he did everything right, and unmounted safely.	
> https://bugzilla.redhat.com/show_bug.cgi?id=728872

James?


-- 
Jens Axboe

