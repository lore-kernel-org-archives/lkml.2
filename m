Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0DVNUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:20:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab0DVNUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:20:46 -0400
Date: Thu, 22 Apr 2010 09:20:25 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/6] [watchdog] convert touch_softlockup_watchdog to
 touch_watchdog
Message-ID: <20100422132025.GZ15159@redhat.com>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com>
 <1271777043-3807-3-git-send-email-dzickus@redhat.com>
 <20100421204559.GB8677@nowhere>
 <20100421213142.GY15159@redhat.com>
 <20100421214610.GE8677@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421214610.GE8677@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 11:46:12PM +0200, Frederic Weisbecker wrote:
> > > Hence I guess we want to keep the current state:
> > > 
> > > - touch_nmi_watchdog() = touch softlockup and nmi watchdogs
> > > - touch_softlockup_watchdog() = only touch softlockup watchdog
> > 
> > Hmm ok I see what you are saying.  A little tweak and I have this
> > compiled-tested only patch that I think satisifies you.
> > 
> > I didn't really touch the touch_nmi_watchdog() code in the kernel, so it
> > still calls a stub function in kernel/watchdog.c.  Add a boolean to that
> > path and I think it accomplishes the logic you are looking for.
> > 
> > Cheers,
> > Don
> 
> 
> Yeah looks good.
> 
> Could you send this patch with a changelog and your sign-off?

I thought about including it when I refresh the patch series with the
other changes you suggested.  Do you prefer it to be separate?

Cheers,
Don
