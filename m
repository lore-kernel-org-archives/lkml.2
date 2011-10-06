Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254Ab1JFRwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:52:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44839 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965181Ab1JFRwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:52:21 -0400
Date: Thu, 6 Oct 2011 18:52:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jon Masters <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
        Adrian Bunk <bunk@stusta.de>, "Frank Ch. Eigler" <fche@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111006175219.GB23532@opensource.wolfsonmicro.com>
References: <4E87B885.50005@zytor.com>
 <201110021354.57995.rjw@sisk.pl>
 <4E88A537.4010008@zytor.com>
 <20111003093239.GB25136@localhost.pp.htv.fi>
 <y0mobxyjazi.fsf@fche.csb>
 <20111003180441.GD3072@localhost.pp.htv.fi>
 <34045.1317760188@turing-police.cc.vt.edu>
 <1317916702.19519.1.camel@constitution.bos.jonmasters.org>
 <20111006173940.GF12975@sirena.org.uk>
 <m3zkheau9i.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3zkheau9i.fsf@intrepid.localdomain>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 07:45:45PM +0200, Krzysztof Halasa wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> > A common approach to this for at least the e-mail portion of the address
> > is to sign the ID with the address and then mail the signed key
> > encrypted to the address, deleting all local copies and requiring that
> > the recipient publish the signature.  This at least demonstrates that
> > the owner of the key can read mail at that address.

> The assumption here is the attacker can read (and write) victim's email.
> It's not about verifying email access or address.

Bear in mind that this is only done after a successful out of band
verification - it's purely about verifying the e-mail portion of the
identity which the person has already asserted that they control.
