Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1JAW1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 18:27:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40212 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309Ab1JAW10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 18:27:26 -0400
X-Sasl-enc: 2lO3rNSzoXIPWvr8galRRWXWCxVlf3FSWEZuIvzbFdq/ 1317508045
Date: Sat, 1 Oct 2011 15:26:59 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111001222659.GA25183@kroah.com>
References: <4E8655CD.90107@zytor.com>
 <20111001140519.GA26662@kroah.com>
 <201110020007.45756.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110020007.45756.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 12:07:45AM +0200, Rafael J. Wysocki wrote:
> On Saturday, October 01, 2011, Greg KH wrote:
> > On Fri, Sep 30, 2011 at 04:50:37PM -0700, H. Peter Anvin wrote:
> > > 2. Create a new PGP/GPG key, and also generate a key revocation
> > >    certificate (but don't import it anywhere -- save it for the
> > >    future) for your new key.  In the near future we are considering
> > >    setting up an escrow service for key revocation certificates.
> > > 
> > >    I recommend using a 4096-bit RSA key.  Given how fast computers are
> > >    these days, there is no reason to use a shorter key.  DSA keys
> > >    should be considered obsolete; substantial weaknesses have been
> > >    found in DSA.
> > > 
> > >    $ gpg --gen-key
> > >    $ gpg -u <key ID> -o <key ID>.revoke --gen-revoke
> > 
> > I would recommend a physical access device for your new gpg key that you
> > create.  I've heard good things about this USB device:
> > 	http://www.crypto-stick.org/
> > and am trying to have a bunch of them at the Kernel Summit this year to
> > hand out to people if they want one.
> 
> This thingie is only capable of operating keys up to 3072-bits it seems.

For older versions of gpg, yes, as of gpg version 2.0.18 it can handle
4k bit keys, so all should be fine.  Read deeper on the site, it says
this somewhere there.

greg k-h
