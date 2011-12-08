Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1LHPlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:41:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab1LHPli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:41:38 -0500
Date: Thu, 8 Dec 2011 10:41:28 -0500
From: Jason Baron <jbaron@redhat.com>
To: Rusty Russell <rusty@ozlabs.org>
Cc: jim.cromie@gmail.com, greg@kroah.com, joe@perches.com,
        bart.vanassche@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/25] kernel/module: replace DEBUGP with pr_debug
Message-ID: <20111208154127.GB2499@redhat.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
 <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
 <1323198694-7186-22-git-send-email-jim.cromie@gmail.com>
 <87zkf5i3yv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zkf5i3yv.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 11:37:52AM +1030, Rusty Russell wrote:
> On Tue,  6 Dec 2011 12:11:31 -0700, jim.cromie@gmail.com wrote:
> > From: Jim Cromie <jim.cromie@gmail.com>
> > 
> > Use more flexible pr_debug.  This allows:
> > 
> >   echo "module module +p" > /dbg/dynamic_debug/control
> > 
> > to turn on debug messages when needed.
> > 
> > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> > ---
> >  kernel/module.c |   44 +++++++++++++++++++-------------------------
> >  kernel/params.c |   14 ++++----------
> >  2 files changed, 23 insertions(+), 35 deletions(-)
> 
> Split into 2 and applied.  This is a win, independent of the rest.
> 

Probably also want to pick up patch 1 in the series too, which actually allows
this one to build ;)

Thanks,

-Jason
