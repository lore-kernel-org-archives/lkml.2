Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1JAOJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 10:09:01 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52109 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761Ab1JAOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 10:08:54 -0400
X-Sasl-enc: x0I+FfekzrcRApDcDUDGNWFHGkZrJv5pORjWzOuaWmec 1317478133
Date: Sat, 1 Oct 2011 07:05:19 -0700
From: Greg KH <greg@kroah.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111001140519.GA26662@kroah.com>
References: <4E8655CD.90107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8655CD.90107@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 04:50:37PM -0700, H. Peter Anvin wrote:
> 2. Create a new PGP/GPG key, and also generate a key revocation
>    certificate (but don't import it anywhere -- save it for the
>    future) for your new key.  In the near future we are considering
>    setting up an escrow service for key revocation certificates.
> 
>    I recommend using a 4096-bit RSA key.  Given how fast computers are
>    these days, there is no reason to use a shorter key.  DSA keys
>    should be considered obsolete; substantial weaknesses have been
>    found in DSA.
> 
>    $ gpg --gen-key
>    $ gpg -u <key ID> -o <key ID>.revoke --gen-revoke

I would recommend a physical access device for your new gpg key that you
create.  I've heard good things about this USB device:
	http://www.crypto-stick.org/
and am trying to have a bunch of them at the Kernel Summit this year to
hand out to people if they want one.

There are also lots of other smart-card form-factor devices that can be
used to store GPG keys.  Some places to purchase these can be found at
links from the above site.

thanks,

greg k-h
