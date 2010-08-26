Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0HZQZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:25:37 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45985 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381Ab0HZQZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:25:36 -0400
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: paulmck@linux.vnet.ibm.com
Cc: Joe Perches <joe@perches.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
In-Reply-To: <20100826161451.GB2367@linux.vnet.ibm.com>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
	 <1282837904.1875.64.camel@Joe-Laptop>
	 <20100826161451.GB2367@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 11:25:33 -0500
Message-ID: <1282839933.8133.11.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 09:14 -0700, Paul E. McKenney wrote:
> On Thu, Aug 26, 2010 at 08:51:44AM -0700, Joe Perches wrote:
> > On Thu, 2010-08-26 at 08:45 -0700, Paul E. McKenney wrote:
> > > Since T: and L: are already taken, add U: for URL of todo list.
> > > Also add the RCU todo list to both the RCU and RCUTORTURE projects.
> > 
> > Hi Paul
> > 
> > I think W: already works perfectly well for this use.
> > 
> > >From MAINTAINERS:
> >         W: Web-page with status/info
> > 
> > > @@ -4801,6 +4802,7 @@ M:	Josh Triplett <josh@freedesktop.org>
> > >  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > >  S:	Supported
> > >  T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > > +U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> > 
> > W:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> > 
> > >  F:	Documentation/RCU/torture.txt
> > >  F:	kernel/rcutorture.c
> > >  
> > > @@ -4826,6 +4828,7 @@ M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > >  W:	http://www.rdrop.com/users/paulmck/rclock/
> > >  S:	Supported
> > >  T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > > +U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> > 
> > W:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> 
> OK, how about the following, then?

Got to say I really think overloading W which means web page/status
information isn't a very good idea:

jejb@mulgrave:~/git/linux-2.6> grep -w 'W:' MAINTAINERS |wc -l
371

We already have ~400 of them ... how's anyone looking for a todo list
going to find the right one in amongst all the others (assuming a newbie
with no subject predisposition simply trying to find any todo list).

James


