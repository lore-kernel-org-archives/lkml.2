Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0HZQnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:43:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:41987 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab0HZQm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:42:58 -0400
Date: Thu, 26 Aug 2010 18:42:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Joe Perches <joe@perches.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
In-Reply-To: <20100826093838.74ab9958@infradead.org>
Message-ID: <alpine.LNX.2.00.1008261841370.1019@pobox.suse.cz>
References: <20100826154537.GA4874@linux.vnet.ibm.com> <1282837904.1875.64.camel@Joe-Laptop> <20100826161451.GB2367@linux.vnet.ibm.com> <1282839933.8133.11.camel@mulgrave.site> <20100826092923.4bdbea69.rdunlap@xenotime.net>
 <20100826093838.74ab9958@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, Arjan van de Ven wrote:

> I have to say that I'm not yet convinced that keeping a todo list in a 
> place that's not with the actual source code does not give me warm fuzzy 
> feelings. Every time we've kept information about the source code 
> separate from our source code it's been a failure; it gets out of sync 
> fast and it just adds to the maintenance.
> 
> A git commit that both fixes an issue and removed the line from the todo 
> file (or moves it to a "done" section, whatever) is the ultimate goal 
> obviously... having a U: seems to go in exactly the opposite direction.
> 
> otoh having a kernel-doc type (eg structured, parsable) way of
> gathering todo items throughout the tree.... that I can see as useful.

I still feel that if maintainer is willing to keep TODO list on web for 
whatever reason (hyperlinks, nice tables, images, whatever), then he 
should be free to do so.

The U: (or whatever) tag in MAINTAINERS file still could point to file in 
the actual sources, in cases maintainer choses to have the list there, of 
course.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
