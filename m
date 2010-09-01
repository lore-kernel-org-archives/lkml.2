Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab0IAAZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 20:25:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab0IAAZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 20:25:01 -0400
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
From: Eric Paris <eparis@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <1283298391.1797.100.camel@Joe-Laptop>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
	 <1282837904.1875.64.camel@Joe-Laptop>
	 <20100826161451.GB2367@linux.vnet.ibm.com>
	 <1282839933.8133.11.camel@mulgrave.site>
	 <20100826092923.4bdbea69.rdunlap@xenotime.net>
	 <20100826093838.74ab9958@infradead.org>
	 <1283275388.1377.216.camel@gandalf.stny.rr.com>
	 <20100831230213.GG2421@linux.vnet.ibm.com>
	 <1283296622.1377.765.camel@gandalf.stny.rr.com>
	 <987664A83D2D224EAE907B061CE93D53015D9B2445@orsmsx505.amr.corp.intel.com>
	 <1283298391.1797.100.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 20:23:35 -0400
Message-ID: <1283300616.3284.213.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 16:46 -0700, Joe Perches wrote:
> On Tue, 2010-08-31 at 16:25 -0700, Luck, Tony wrote:
> > >Then, the list is maintained outside of mainline (in the subsystem git
> > >tree) and will automatically update mainline in the next merge window
> > >when the tree is pulled.
> > 
> > But this would mean that the version of the todo list in Linus' tree
> > is usually a release (3 months) out of date.  It would be a good idea
> > for a list maintained this way to include instructions on how to find
> > the current version, lest some unsuspecting person waste time working
> > on items that are already fixed and waiting for the next merge.
> 
> There are already reasonable mechanisms for this.
> 
> It's perfectly fine to have multiple T: entries,
> one for a current tree, another for a -next tree.

If I just downloaded a big tar ball and started trolling randomly
through the source how am I going to know what the MAINTAINERS file is?
How am I going to know that todo entries should be located by opening
the magic file called MAINTAINERS, looking for T: entries, and then
checking out the listed web page?

random todo files scattered around the kernel, all with references that
might duplicate MAINTAINERS info, but which make it clear to a complete
newbie how development for that subsys works, seems simple and easy.

subsys maintainers might want to put all kinds of info in there, what
tree to develop against (rarely a tar ball of Linus' tree), pointers to
particularly relevant Documentation/ files, how they like to get
patches, where those patches usually end getting applied, what lists and
cc's to use, things like that.

I just think that hoping a newbie is going to naturally know MAINTAINERS
isn't the best.

-Eric

