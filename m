Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1JBXJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 19:09:34 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36589 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab1JBXJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 19:09:28 -0400
X-Sasl-enc: S0hAkLRehMNdApgZvOkm03uZ1fSY/WaZPzn4PDQmWICJ 1317596967
Date: Sun, 2 Oct 2011 16:09:21 -0700
From: Greg KH <greg@kroah.com>
To: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111002230921.GA12701@kroah.com>
References: <4E8655CD.90107@zytor.com>
 <20111001140519.GA26662@kroah.com>
 <CABMQnVLd3VpNntgUEiCYrjCAVt4dAtO2H5C3iAsfEv0kA3URrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABMQnVLd3VpNntgUEiCYrjCAVt4dAtO2H5C3iAsfEv0kA3URrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 08:02:39AM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> 2011/10/1 Greg KH <greg@kroah.com>:
> > On Fri, Sep 30, 2011 at 04:50:37PM -0700, H. Peter Anvin wrote:
> >> 2. Create a new PGP/GPG key, and also generate a key revocation
> >>    certificate (but don't import it anywhere -- save it for the
> >>    future) for your new key.  In the near future we are considering
> >>    setting up an escrow service for key revocation certificates.
> >>
> >>    I recommend using a 4096-bit RSA key.  Given how fast computers are
> >>    these days, there is no reason to use a shorter key.  DSA keys
> >>    should be considered obsolete; substantial weaknesses have been
> >>    found in DSA.
> >>
> >>    $ gpg --gen-key
> >>    $ gpg -u <key ID> -o <key ID>.revoke --gen-revoke
> >
> > I would recommend a physical access device for your new gpg key that you
> > create.  I've heard good things about this USB device:
> >        http://www.crypto-stick.org/
> > and am trying to have a bunch of them at the Kernel Summit this year to
> > hand out to people if they want one.
> >
> > There are also lots of other smart-card form-factor devices that can be
> > used to store GPG keys.  Some places to purchase these can be found at
> > links from the above site.
> 
> Maybe you know , there are the following projects, too.
>  http://www.fsij.org/gnuk/

Yes, I think I saw the presentation about this at the last LinuxCon
Tokyo (or was it the year before?)

It looks like a great project, but sometimes you want something already
built as you have enough hobbies as it is :)

thanks,

greg k-h
