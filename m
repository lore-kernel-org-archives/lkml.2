Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0HZRBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:01:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61774 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0HZRBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tc427ovBN3WHts2LyW0bdZPqZeP40LLx0ozIEcbS98efRTM7IysKnDzaN1YMC/Kczp
         O5FKTGDxi7GZ1em/ufKz/Af8emYPIa/rqM5CJe8KkL7hcCj77Fq3wgt7S50wZa6zzut5
         LzVNZUcW5ehN0eHqh8w2QMUf/VrUl4dsIq9hw=
Date: Thu, 26 Aug 2010 10:00:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Joe Perches <joe@perches.com>, mingo@elte.hu
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
Message-ID: <20100826170058.GA6761@core.coreip.homeip.net>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
 <1282837904.1875.64.camel@Joe-Laptop>
 <20100826161451.GB2367@linux.vnet.ibm.com>
 <1282839933.8133.11.camel@mulgrave.site>
 <20100826092923.4bdbea69.rdunlap@xenotime.net>
 <20100826093838.74ab9958@infradead.org>
 <alpine.LNX.2.00.1008261841370.1019@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1008261841370.1019@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 06:42:55PM +0200, Jiri Kosina wrote:
> On Thu, 26 Aug 2010, Arjan van de Ven wrote:
> 
> > I have to say that I'm not yet convinced that keeping a todo list in a 
> > place that's not with the actual source code does not give me warm fuzzy 
> > feelings. Every time we've kept information about the source code 
> > separate from our source code it's been a failure; it gets out of sync 
> > fast and it just adds to the maintenance.
> > 
> > A git commit that both fixes an issue and removed the line from the todo 
> > file (or moves it to a "done" section, whatever) is the ultimate goal 
> > obviously... having a U: seems to go in exactly the opposite direction.
> > 

TODO might disappear without implementation, if you decide that the idea
wasn't a good one after all.

> > otoh having a kernel-doc type (eg structured, parsable) way of
> > gathering todo items throughout the tree.... that I can see as useful.
> 
> I still feel that if maintainer is willing to keep TODO list on web for 
> whatever reason (hyperlinks, nice tables, images, whatever), then he 
> should be free to do so.
>

Yep, I do not want to be restricted to updating TODO during merge window
only as the changes to the list are not likely to count as bugfixes ;)

-- 
Dmitry
