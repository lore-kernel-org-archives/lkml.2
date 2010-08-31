Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0HaXqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:46:35 -0400
Received: from mail.perches.com ([173.55.12.10]:1134 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab0HaXqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:46:33 -0400
Subject: RE: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
From: Joe Perches <joe@perches.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53015D9B2445@orsmsx505.amr.corp.intel.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 16:46:31 -0700
Message-ID: <1283298391.1797.100.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 16:25 -0700, Luck, Tony wrote:
> >Then, the list is maintained outside of mainline (in the subsystem git
> >tree) and will automatically update mainline in the next merge window
> >when the tree is pulled.
> 
> But this would mean that the version of the todo list in Linus' tree
> is usually a release (3 months) out of date.  It would be a good idea
> for a list maintained this way to include instructions on how to find
> the current version, lest some unsuspecting person waste time working
> on items that are already fixed and waiting for the next merge.

There are already reasonable mechanisms for this.

It's perfectly fine to have multiple T: entries,
one for a current tree, another for a -next tree.

SECTION - name
M:	who <email.address>
T:	git <url>
T:	git <url-next>
F:	dir/file_pattern

Linus rarely seems to object to pulling Documentation updates.

Note the Documentation updates after any -rc2

$ for ((i=25 ; i<36 ; i++)) ; do	\
	cv=v2.6.$i-rc2..v2.6.$i ;	\
	echo -n "$cv: " ;		\
	git log --pretty=oneline --no-merges $cv -- Documentation | wc -l; \
done
v2.6.25-rc2..v2.6.25: 87
v2.6.26-rc2..v2.6.26: 48
v2.6.27-rc2..v2.6.27: 65
v2.6.28-rc2..v2.6.28: 67
v2.6.29-rc2..v2.6.29: 50
v2.6.30-rc2..v2.6.30: 44
v2.6.31-rc2..v2.6.31: 35
v2.6.32-rc2..v2.6.32: 74
v2.6.33-rc2..v2.6.33: 31
v2.6.34-rc2..v2.6.34: 32
v2.6.35-rc2..v2.6.35: 8


