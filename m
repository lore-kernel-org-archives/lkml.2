Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1JAWFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 18:05:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42006 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab1JAWF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 18:05:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Date: Sun, 2 Oct 2011 00:07:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <4E8655CD.90107@zytor.com> <20111001140519.GA26662@kroah.com>
In-Reply-To: <20111001140519.GA26662@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110020007.45756.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 01, 2011, Greg KH wrote:
> On Fri, Sep 30, 2011 at 04:50:37PM -0700, H. Peter Anvin wrote:
> > 2. Create a new PGP/GPG key, and also generate a key revocation
> >    certificate (but don't import it anywhere -- save it for the
> >    future) for your new key.  In the near future we are considering
> >    setting up an escrow service for key revocation certificates.
> > 
> >    I recommend using a 4096-bit RSA key.  Given how fast computers are
> >    these days, there is no reason to use a shorter key.  DSA keys
> >    should be considered obsolete; substantial weaknesses have been
> >    found in DSA.
> > 
> >    $ gpg --gen-key
> >    $ gpg -u <key ID> -o <key ID>.revoke --gen-revoke
> 
> I would recommend a physical access device for your new gpg key that you
> create.  I've heard good things about this USB device:
> 	http://www.crypto-stick.org/
> and am trying to have a bunch of them at the Kernel Summit this year to
> hand out to people if they want one.

This thingie is only capable of operating keys up to 3072-bits it seems.

Thanks,
Rafael
