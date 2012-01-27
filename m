Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2A0J4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:56:43 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:37479 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2A0J4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:56:41 -0500
Message-ID: <4F2274CA.7020809@atmel.com>
Date: Fri, 27 Jan 2012 10:56:26 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <rmk@arm.linux.org.uk>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: merge of the arm tree into the at91 tree
References: <20120127093619.f2c90c6aa8b542134a157956@canb.auug.org.au>
In-Reply-To: <20120127093619.f2c90c6aa8b542134a157956@canb.auug.org.au>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/26/2012 11:36 PM, Stephen Rothwell :
> Hi all,
> 
> I noticed that the for-next branch of the arm tree has been merged 
> into the at91 tree.  My understanding (and Russell, please correct 
> me if I am wrong) is that the for-next branch is *not* stable and 
> may be rebased. This will cause all sorts of problems in
> linux-next in the future (and also when Russell or the arm=soc guys
> merge the at91 tree into theirs).
> 
> In fact, I am going to have problems today as Russell has already 
> rebase his for-next branch.  :-(
> 
> I assume that the merge was done to fix some conflicts or pick up 
> some functionality that is in Russell's tree.  This should be done 
> by merging topic branch(es) of that tree that Russell has 
> explicitly said are stable.

Yes, I was anticipating a stable branch from Russell and never should
have pushed into a branch that would have gone to linux-next: My
mistake, sorry.

Note that my intention was not to use this branch or one based on
rmk/for-next in any "pull request". It was just a hint for people that
wanted to work on at91 for 3.4...

So, Stephen, can I ask you to remove the at91-next branch from your
pull list. For the moment we can rely on arm-soc guys to experiment
our changes in linux-next. It may be simpler for everyone.

thanks for your understanding, best regards,
- -- 
Nicolas Ferre
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPInTFAAoJEAf03oE53VmQ01UIALIkAxoj3Oxou45+Ts0hjqCk
ddQpqXsoZt44B/b+M+b2wPKK+stmjAVXT8KQJporgckmJyatc/H3BOdaCw5a4rGR
PPrBjEZRx+cH6IXnzII2b73MkdvmKrICOlKpcuIlJiXPcpWet0J1K4lmMWxDPC2D
zGeTFMqqUYMOxxADtRZhsHo/ryZivtaZf9LfYS5pYc7u4vhqjkCt8q07NabgIRaL
GpfyXSLFl30Sqx53Di6DLr0OUUmHGPvjDj1xR3yqdeXtO9vpoiwZequlVX+PYboL
S6OUPYjrDy8uRTNNkz1X8erruOx/y0T87/l4SHt28Aoz9p9sobcykcyRqQyHGJw=
=YhKe
-----END PGP SIGNATURE-----
