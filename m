Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab0IXSZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:25:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241Ab0IXSZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:25:02 -0400
Date: Fri, 24 Sep 2010 14:24:37 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        linux-ide@vger.kernel.org
Subject: Re: hibernation hangs with ATA errors (lockup_detector bug)
Message-ID: <20100924182437.GR26290@redhat.com>
References: <4C03C608.1040600@gmail.com>
 <20100601135004.GP15159@redhat.com>
 <4C051D44.7040203@gmail.com>
 <20100602184459.GA15159@redhat.com>
 <4C0B3E94.6020506@gmail.com>
 <4C80B338.6020701@gmail.com>
 <20100903135613.GV4879@redhat.com>
 <4C9CBF4A.9060302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9CBF4A.9060302@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 06:10:02PM +0300, Jiri Slaby wrote:
> On 09/03/2010 04:56 PM, Don Zickus wrote:
> > On Fri, Sep 03, 2010 at 10:35:04AM +0200, Jiri Slaby wrote:
> >> On 06/06/2010 08:22 AM, Jiri Slaby wrote:
> >>> On 06/02/2010 08:44 PM, Don Zickus wrote:
> >>>> --- a/kernel/watchdog.c
> >>>> +++ b/kernel/watchdog.c
> >>>> @@ -550,8 +550,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >>>>  		break;
> >>>>  	case CPU_ONLINE:
> >>>>  	case CPU_ONLINE_FROZEN:
> >>>> -		if (watchdog_enable(hotcpu))
> >>>> -			return NOTIFY_BAD;
> >>>> +		watchdog_enable(hotcpu)
> >>>
> >>> This fixes the problem indeed.
> >>
> >> Hi, was this fixed somehow? I still use this hunk and don't know if it
> >> is needed:
> > 
> > I have to go re-review the problem again.  I might have forgot to bring it
> > in.  Thanks for reminding me!
> 
> Reminder #2 :). Any updates?

No. I suck.  I was sidetracked on other stuff.  Let me put that together
today.

Thanks again for reminding me.

Cheers,
Don
