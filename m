Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0HZPvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:51:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1365 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0HZPvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:51:46 -0400
Subject: Re: [PATCH] MAINTAINERS: add U: for URL of todo list, add RCU todo
 list
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jkosina@suse.cz,
        ksummit-2010-discuss@lists.linux-foundation.org
In-Reply-To: <20100826154537.GA4874@linux.vnet.ibm.com>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 08:51:44 -0700
Message-ID: <1282837904.1875.64.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 08:45 -0700, Paul E. McKenney wrote:
> Since T: and L: are already taken, add U: for URL of todo list.
> Also add the RCU todo list to both the RCU and RCUTORTURE projects.

Hi Paul

I think W: already works perfectly well for this use.

>From MAINTAINERS:
        W: Web-page with status/info

> @@ -4801,6 +4802,7 @@ M:	Josh Triplett <josh@freedesktop.org>
>  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>  S:	Supported
>  T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> +U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html

W:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html

>  F:	Documentation/RCU/torture.txt
>  F:	kernel/rcutorture.c
>  
> @@ -4826,6 +4828,7 @@ M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>  W:	http://www.rdrop.com/users/paulmck/rclock/
>  S:	Supported
>  T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> +U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html

W:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html


