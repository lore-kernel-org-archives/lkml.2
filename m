Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945972Ab2ERNGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:06:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51410 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945932Ab2ERNGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:06:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] ARM: at91: Add ADC driver to at91sam9260/at91sam9g20 dtsi files
Date: Fri, 18 May 2012 13:03:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com, maxime.ripard@free-electrons.com,
        olof@lixom.net, linux-next@vger.kernel.org
References: <4FB3B1F3.6080102@atmel.com> <20120517150601.GA28104@kroah.com> <20120518084446.a7b229074ea215fd7bcd1eb8@canb.auug.org.au>
In-Reply-To: <20120518084446.a7b229074ea215fd7bcd1eb8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205181303.28535.arnd@arndb.de>
X-Provags-ID: V02:K0:aHkgUGOObRjpp8YazShCHY6k+3zQWzqAkFEkrSgmwDW
 aWMBriiCzcHcfE8XCSBH4T70EtSLZ+Z4bS7z40rDVmF61wvMa9
 q+gK12bBHWAafqLrd8qxthDwO46bfD7NON/e1J/gdRbdMkjoww
 MZFKLW3cdIMXQjf2K6NCfk5u+m+GpMnW2AKyam/8C4r3FzEWVf
 gt/eNS8fqylt/RWA5Zoq/bbFZ2tC60SxVYbUli9kF/RZyuNBw5
 vT4RK03NzPlwkGuXdxTyl6h5thjt8yolxH08Oj7BWNYg5w+t1W
 9Bn3o+ZpvSxnCQV7nuTCTvRVWZkwGZzF65OpfPJyzVMWsL+XMX
 jgxzRPTo/S5L3zxtm2fM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2012, Stephen Rothwell wrote:
> On Thu, 17 May 2012 08:06:01 -0700 Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, May 16, 2012 at 06:50:54PM +0000, Arnd Bergmann wrote:
> > > On Wednesday 16 May 2012, Nicolas Ferre wrote:
> > > > Now that the bulk of at91sam9g20-related nodes are located in at91sam9260.dtsi,
> > > > we have to re-create the path to this ADC node for SoC specific parts.
> > > > 
> > > > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > > 
> > > Should we apply this patch in arm-soc so that Greg can drop the hunk that
> > > no longer applies?
> > 
> > It's not a "no longer applies", it's a "this does not merge".  The patch
> > is in my tree, unless you want me to revert it, it's going to stay there
> > until it goes to Linus.
> 
> Just apply the patch to the arm-soc tree - then the merge resolution
> becomes "use the arm-soc version".   There is no need for Greg to revert
> the other patch.
> 

Yes, good point.

I've applied the patch on the at91/dt branch now.

	Arnd
