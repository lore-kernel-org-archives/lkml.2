Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0DVS4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 14:56:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:63288 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab0DVS4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 14:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Br3A+2dIB6laL4FLDpj67Gjk/vTRIuzk7Jffj+qRXD/jvXqbRXB79s5+128HInPDGo
         g6pFbLSO6amFnpLEx4R/kNpuHyoZ1qeCIh6/puKL2zAObOLyF0LQOtvtChc4i4x1mTy0
         g+7+nuRTRlzuXgyW0vRoqOWkaxd0HkE2CvmJg=
Date: Thu, 22 Apr 2010 20:53:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/6] [watchdog] convert touch_softlockup_watchdog to
	touch_watchdog
Message-ID: <20100422185333.GB5600@nowhere>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com> <1271777043-3807-3-git-send-email-dzickus@redhat.com> <20100421204559.GB8677@nowhere> <20100421213142.GY15159@redhat.com> <20100421214610.GE8677@nowhere> <20100422132025.GZ15159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422132025.GZ15159@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 09:20:25AM -0400, Don Zickus wrote:
> On Wed, Apr 21, 2010 at 11:46:12PM +0200, Frederic Weisbecker wrote:
> > > > Hence I guess we want to keep the current state:
> > > > 
> > > > - touch_nmi_watchdog() = touch softlockup and nmi watchdogs
> > > > - touch_softlockup_watchdog() = only touch softlockup watchdog
> > > 
> > > Hmm ok I see what you are saying.  A little tweak and I have this
> > > compiled-tested only patch that I think satisifies you.
> > > 
> > > I didn't really touch the touch_nmi_watchdog() code in the kernel, so it
> > > still calls a stub function in kernel/watchdog.c.  Add a boolean to that
> > > path and I think it accomplishes the logic you are looking for.
> > > 
> > > Cheers,
> > > Don
> > 
> > 
> > Yeah looks good.
> > 
> > Could you send this patch with a changelog and your sign-off?
> 
> I thought about including it when I refresh the patch series with the
> other changes you suggested.  Do you prefer it to be separate?


I was about to apply the series because there were mostly minor
things to fix.

But I would indeed prefer you repost a new series with the reviews
addressed, whatever this patch is a delta or a fixed existing one.
I will more likely forget things in the middle than you will.

Thanks.

