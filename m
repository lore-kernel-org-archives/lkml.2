Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab1JAVbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 17:31:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab1JAVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 17:31:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Date: Sat, 1 Oct 2011 23:33:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
References: <4E8655CD.90107@zytor.com>
In-Reply-To: <4E8655CD.90107@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110012333.55428.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, October 01, 2011, H. Peter Anvin wrote:
> Hi all,
> 
> Since the kernel.org status announcement last week a number of you
> have contacted me about re-establishing credentials.  In order to
> establish a proper PGP web of trust we need keys that are cross-signed
> by other developers.  As such, we ask that you follow the following
> steps:
> 
> 1. Make sure your systems are uncompromised.  We will address specific
>    recommended steps for that in a separate email.
> 
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

OK, how long should the new key be valid?

Rafael
