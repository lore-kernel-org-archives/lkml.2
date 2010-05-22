Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0EVKbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 06:31:35 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:47601 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753744Ab0EVKbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 06:31:33 -0400
Date: Sat, 22 May 2010 20:31:02 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "michael-dev@fami-braun.de"@ogre.sisk.pl,
       David Miller <davem@davemloft.net>, Matt Mackall <mpm@selenic.com>
Subject: Re: [Bug #15601] [BUG] SLOB breaks Crypto
Message-ID: <20100522103102.GA11788@gondor.apana.org.au>
References: <10aqDnTJcLO.A.mLE.48y5LB@chimera> <HqroMXsT-CJ.A.qYG.f_y5LB@chimera> <AANLkTikXPfDVhwsUMr5yDpsvgk06QrMFXpG22k8T0ydi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikXPfDVhwsUMr5yDpsvgk06QrMFXpG22k8T0ydi@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 01:22:57PM +0300, Pekka Enberg wrote:
> On Mon, May 10, 2010 at 12:17 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15601
> > Subject         : [BUG] SLOB breaks Crypto
> > Submitter       : michael-dev@fami-braun.de
> > Date            : 2010-03-15 13:39 (56 days old)
> > Message-ID      : <4B9E38AF.70309@fami-braun.de>
> > References      : http://marc.info/?l=linux-kernel&m=126866044724539&w=2
> 
> Herbert, David, Matt, this bug should be fixed by the following two
> commits, right?
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=18eb8ea6ee4cc9ed39b45f95b734f523bcfb586b
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=273fca0ecad9305247043815e185d1bfd04047d4

Yes.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
