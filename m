Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0HZPvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:51:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0HZPvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:51:22 -0400
Date: Thu, 26 Aug 2010 17:51:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, mingo@elte.hu,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: Re: [PATCH] MAINTAINERS: add U: for URL of todo list, add RCU todo
 list
In-Reply-To: <20100826154537.GA4874@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1008261748520.1019@pobox.suse.cz>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, Paul E. McKenney wrote:

> Since T: and L: are already taken, add U: for URL of todo list.
> Also add the RCU todo list to both the RCU and RCUTORTURE projects.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3f21c27..1c57186 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -103,6 +103,7 @@ Descriptions of section entries:
>  	      matches patches or files that contain one or more of the words
>  	      printk, pr_info or pr_err
>  	   One regex pattern per line.  Multiple K: lines acceptable.
> +	U: URL of todo list.
>  
>  Note: For the hard of thinking, this list is meant to remain in alphabetical
>  order. If you could add yourselves to it in alphabetical order that would be
> @@ -4801,6 +4802,7 @@ M:	Josh Triplett <josh@freedesktop.org>
>  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>  S:	Supported
>  T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> +U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
>  F:	Documentation/RCU/torture.txt
>  F:	kernel/rcutorture.c
>  
> @@ -4826,6 +4828,7 @@ M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>  W:	http://www.rdrop.com/users/paulmck/rclock/
>  S:	Supported
>  T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> +U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
>  F:	Documentation/RCU/
>  F:	include/linux/rcu*
>  F:	include/linux/srcu*

While you are at it, I am aware at least of these additional ones:

http://vger.kernel.org/~davem/net_todo.html
http://wireless.kernel.org/en/developers/todo-list
https://ieee1394.wiki.kernel.org/index.php/To_Do
http://selinuxproject.org/page/Kernel_Development

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
