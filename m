Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2F1TIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:08:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45304 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab2F1TIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:08:35 -0400
Date: Thu, 28 Jun 2012 09:42:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Dave Jones <davej@redhat.com>,
        David Miller <davem@davemloft.net>, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] net: nfc: fix panic in accept()
Message-ID: <20120628134254.GB2115@tuxdriver.com>
References: <20120611145700.GY22557@sortiz-mobl>
 <1339426778.6001.2312.camel@edumazet-glaptop>
 <20120611152007.GZ22557@sortiz-mobl>
 <1339433810.4999.65.camel@lappy>
 <20120611172545.GA1776@redhat.com>
 <CA+1xoqcwr-5dzHvqkt9x0-xj9EFAywVfva=asbHXvX-LSBWqdA@mail.gmail.com>
 <1340639612.10893.84.camel@edumazet-glaptop>
 <20120625171532.GB16275@sortiz-mobl>
 <CA+1xoqfy21wOh2myV0D6iBDqoZ3YmkwNZwKBVXLU75zePOGi4w@mail.gmail.com>
 <20120628125612.GG4846@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628125612.GG4846@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 02:56:12PM +0200, Samuel Ortiz wrote:
> Hi Sasha,
> 
> On Thu, Jun 28, 2012 at 02:11:38PM +0200, Sasha Levin wrote:
> > Hi Samuel,
> > 
> > On Mon, Jun 25, 2012 at 7:15 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > > Hi Eric,
> > >
> > > On Mon, Jun 25, 2012 at 05:53:32PM +0200, Eric Dumazet wrote:
> > >> From: Eric Dumazet <edumazet@google.com>
> > >>
> > >> Sasha Levin reported following panic :
> > > I applied a similar patch, more consistent with the rest of the NFC socket
> > > code, still with you as the author. See here:
> > >
> > > http://git.kernel.org/?p=linux/kernel/git/sameo/nfc-3.0.git;a=commit;h=631c301f20558525a641fadffc0126affd3dc4a4
> > 
> > Could this tree be included in -next please?
> No, wireless-next is already included in -next. The above patch is making its
> way upstream, it's in the wireless.git tree and should hit davem's net tree
> soon.

FWIW, lots (or most?) of the bug fix trees get pulled into -next
as well.  Having the nfc tree go there makes sense to me.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
