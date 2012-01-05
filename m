Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab2AEPjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:39:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662Ab2AEPjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:39:06 -0500
Date: Thu, 5 Jan 2012 10:38:59 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: gleb@redhat.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jump label: close race in jump_label_inc() vs.
 jump_label_dec()
Message-ID: <20120105153859.GB10850@redhat.com>
References: <201201041532.q04FWbBl022103@int-mx10.intmail.prod.int.phx2.redhat.com>
 <1325774396.12696.49.camel@gandalf.stny.rr.com>
 <20120105153041.GA10850@redhat.com>
 <1325777664.12696.50.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325777664.12696.50.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 10:34:24AM -0500, Steven Rostedt wrote:
> On Thu, 2012-01-05 at 10:30 -0500, Jason Baron wrote:
> 
> > That said, until we have a use-case that would excercise this race,
> > I'm ok with having it be a higher level bug as Gleb pointed out. So how about a
> > WARN() for this case. I'll send as a separate patch, if people are ok
> > with it.
> 
> You mean a WARN_ON(key->enabled < 0) ?
> 

yes.

> for that, yeah I'm fine with it.
> 
> -- Steve

Ok, I'll post a patch for that.

Thanks,

-Jason
