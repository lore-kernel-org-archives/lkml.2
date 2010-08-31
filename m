Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0HaRXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 13:23:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab0HaRXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 13:23:12 -0400
X-Authority-Analysis: v=1.1 cv=h9FjAN2ougM9pVhvDq3M6+cWFo1DP5/t8S/Ny2XAPyw= c=1 sm=0 a=MSnKhT_c3jYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=I128M_0NUVUE20tNh-AA:9 a=aiyffvmgtOSrluYnstcA:7 a=CQ5UrElhmgQdPM4pF1JOgiD1l3MA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
From: Steven Rostedt <rostedt@goodmis.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Joe Perches <joe@perches.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
In-Reply-To: <20100826093838.74ab9958@infradead.org>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
	 <1282837904.1875.64.camel@Joe-Laptop>
	 <20100826161451.GB2367@linux.vnet.ibm.com>
	 <1282839933.8133.11.camel@mulgrave.site>
	 <20100826092923.4bdbea69.rdunlap@xenotime.net>
	 <20100826093838.74ab9958@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 Aug 2010 13:23:08 -0400
Message-ID: <1283275388.1377.216.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 09:38 -0700, Arjan van de Ven wrote:

> I have to say that I'm not yet convinced that keeping a todo list in a
> place that's not with the actual source code does not give me warm
> fuzzy feelings. Every time we've kept information about the source code
> separate from our source code it's been a failure; it gets out of sync
> fast and it just adds to the maintenance.
> 
> A git commit that both fixes an issue and removed the line from the
> todo file (or moves it to a "done" section, whatever) is the ultimate
> goal obviously... having a U: seems to go in exactly the opposite
> direction.
> 
> otoh having a kernel-doc type (eg structured, parsable) way of
> gathering todo items throughout the tree.... that I can see as useful.

We could add a toplevel "todo/" directory, with each project file in it
and a list of things todo. When the todo is done, that same commit could
remove the todo item.

Just a worthless thought ;-)

-- Steve


