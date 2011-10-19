Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab1JSU5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 16:57:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1JSU5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 16:57:09 -0400
Date: Wed, 19 Oct 2011 16:57:03 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/26] dynamic_debug: add pending queries, etc (~resend)
Message-ID: <20111019205703.GC7391@redhat.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
 <20111018185218.GA22653@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018185218.GA22653@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 11:52:18AM -0700, Greg KH wrote:
> Date: Tue, 18 Oct 2011 11:52:18 -0700
> From: Greg KH <greg@kroah.com>
> To: jim.cromie@gmail.com, jbaron@redhat.com
> Cc: joe@perches.com, bart.vanassche@gmail.com, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 00/26] dynamic_debug: add pending queries, etc (~resend)
> User-Agent: Mutt/1.5.21 (2010-09-15)
> 
> On Fri, Oct 07, 2011 at 02:33:06PM -0600, jim.cromie@gmail.com wrote:
> > This is essentially a rebase, resend, with trivial changes:
> > - drops scx200 - off topic
> > - adds pr_cont_once tweak - remove pr_fmt
> > as before, it has:
> > - Doc tweaks per Randy Dunlap
> > - pr_fmt_$severity, suggested by Joe Perches
> > - does not change pr_fmt() default, per Joe
> > 
> > Rebased onto git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
> > + Jason's 8-12/12 which havent made it into driver-core
> > Ive not resent them here.
> 
> As stated before, I'm not going to be able to accept these until I get
> Jason's ack on them.
> 
> Jason?
> 

Hi Greg,

Yes, I just replied, in a separate thread on which patches in the series
I'd like to include, and which I'd like to drop for now. I expect we'll
need another re-post of the series once we've reached a consensus.

Thanks,

-Jason
