Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2LUTNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 14:13:51 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49066 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751085Ab2LUTNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 14:13:48 -0500
Message-ID: <1356117229.19585.20.camel@joe-AO722>
Subject: Re: [PATCH 00/19] MAINTAINERS: fix file patterns
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Fri, 21 Dec 2012 11:13:49 -0800
In-Reply-To: <1356116656.21178.1@driftwood>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
	 <1355264351.24219.8.camel@joe-AO722> <1356105142.19585.13.camel@joe-AO722>
	 <1356116656.21178.1@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 13:04 -0600, Rob Landley wrote:
> On 12/21/2012 09:52:22 AM, Joe Perches wrote:
> > On Tue, 2012-12-11 at 14:19 -0800, Joe Perches wrote:
> > > On Tue, 2012-12-11 at 19:49 -0200, Cesar Eduardo Barros wrote:
> > > > I could not find the maintainer for the MAINTAINERS file, so  
> > sending
> > > > directly to Linus. Sorry if I am mistaken.
> > >
> > > Thanks Cesar.
> > >
> > > Most maintainers patches are picked up by Andrew Morton (cc'd)
> 
> Which implies... (attached because Balsa damages whitespace).

Maybe something like:

MAINTAINERS: UPDATES TO THIS FILE
M:	Andrew Morton <akpm@linux-foundation.org>
S:	Odd fixes
F:	MAINTAINERS

But then Andrew tried to get me added as a checkpatch
maintainer and I demurred, so he'll have to add himself if
he wants.

Anyway, even without a specific MAINTAINERS maintainer entry,
get_maintainers uses git log history and Andrew shows up anyway.

$ ./scripts/get_maintainer.pl -f MAINTAINERS 
Andrew Morton <akpm@linux-foundation.org> (commit_signer:51/331=15%)
Mauro Carvalho Chehab <mchehab@redhat.com> (commit_signer:39/331=12%)
Joe Perches <joe@perches.com> (commit_signer:25/331=8%)
"David S. Miller" <davem@davemloft.net> (commit_signer:25/331=8%)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (commit_signer:22/331=7%)
linux-kernel@vger.kernel.org (open list)


