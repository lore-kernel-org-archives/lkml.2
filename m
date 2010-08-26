Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0HZQPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:15:03 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49206 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab0HZQO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:14:59 -0400
Date: Thu, 26 Aug 2010 09:14:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jkosina@suse.cz,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: Re: [PATCH] MAINTAINERS: add U: for URL of todo list, add RCU todo
 list
Message-ID: <20100826161451.GB2367@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100826154537.GA4874@linux.vnet.ibm.com>
 <1282837904.1875.64.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282837904.1875.64.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 08:51:44AM -0700, Joe Perches wrote:
> On Thu, 2010-08-26 at 08:45 -0700, Paul E. McKenney wrote:
> > Since T: and L: are already taken, add U: for URL of todo list.
> > Also add the RCU todo list to both the RCU and RCUTORTURE projects.
> 
> Hi Paul
> 
> I think W: already works perfectly well for this use.
> 
> >From MAINTAINERS:
>         W: Web-page with status/info
> 
> > @@ -4801,6 +4802,7 @@ M:	Josh Triplett <josh@freedesktop.org>
> >  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >  S:	Supported
> >  T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > +U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> 
> W:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> 
> >  F:	Documentation/RCU/torture.txt
> >  F:	kernel/rcutorture.c
> >  
> > @@ -4826,6 +4828,7 @@ M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >  W:	http://www.rdrop.com/users/paulmck/rclock/
> >  S:	Supported
> >  T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > +U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> 
> W:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html

OK, how about the following, then?

							Thanx, Paul

------------------------------------------------------------------------

commit 47d3177f3435e2600c98370dc07ed20a3a585c32
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Thu Aug 26 08:59:13 2010 -0700

    MAINTAINERS: add RCU todo list
    
    Add the RCU todo list to RCUTORTURE and RCU.  Also add a note to
    W: stating that it may be used for todo list information.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3f21c27..e02882b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -70,7 +70,7 @@ Descriptions of section entries:
 	P: Person (obsolete)
 	M: Mail patches to: FullName <address@domain>
 	L: Mailing list that is relevant to this area
-	W: Web-page with status/info
+	W: Web-page with status/info/todo
 	Q: Patchwork web based patch tracking system site
 	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
 	S: Status, one of the following:
@@ -4799,6 +4799,8 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+W:	http://www.rdrop.com/users/paulmck/RCU/
+W:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
 S:	Supported
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/torture.txt
@@ -4823,7 +4825,8 @@ F:	net/rds/
 READ-COPY UPDATE (RCU)
 M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
-W:	http://www.rdrop.com/users/paulmck/rclock/
+W:	http://www.rdrop.com/users/paulmck/RCU/
+W:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
 S:	Supported
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/
