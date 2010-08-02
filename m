Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab0HBENb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 00:13:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46240 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab0HBEN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 00:13:28 -0400
X-Sasl-enc: wMY0sU0Xq45JQur/zNYE870DliEBMS6Tevv1861nVJ0V 1280722405
Date: Mon, 2 Aug 2010 01:13:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [Pkg-sysvinit-devel] Bug#587665: Safety of early boot init of
 /dev/random seed
Message-ID: <20100802041321.GB6863@khazad-dum.debian.net>
References: <4C2BDCF0.5080203@debian.org>
 <20100701141022.GA3811@login1.uio.no>
 <20100701171357.GE4789@khazad-dum.debian.net>
 <20100702064415.GE3811@login1.uio.no>
 <20100702232919.GA14437@login2.uio.no>
 <20100703012833.GA20929@khazad-dum.debian.net>
 <20100703151636.GB23648@khazad-dum.debian.net>
 <20100703160819.GA12343@khazad-dum.debian.net>
 <1278355233.9937.21.camel@calx>
 <1280703171.10108.35.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280703171.10108.35.camel@fermat.scientia.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010, Christoph Anton Mitterer wrote:
> > > > 2. How dangerous it is to feed the pool with stale seed data in the next
> > > >    boot (i.e. in a failure mode where we do not regenerate the seed file) ?
> > 
> > Not at all.
> 
> Are the above to statements also true for possibly "evil" random data?

Yes.  I think you could consider that seeding with evil data does as much
damage as not seeding at all.

Unless there is a big bad bug somewhere, in which case we'd very much like
to know about it ;-)

> Working with a Gird-CA for the LHC - we're always interested in nice
> tokens like:
> http://www.entropykey.co.uk/
> 
> Unfortunately it's never really clear how well their contribution would
> actually be.... and the paranoid below us could even believe, that
> mighty government organisations have such devices hacked in order to
> harm our crypto ;)

Well, if you overestimate the entropy that thing will output, it might cause
harm.  If it has a self-sabotage device that is intelligent enough not to
fail the tests done by the application that feeds entropy to the kernel, it
might cause harm.  The list goes on and on...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
