Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967521Ab2EPNoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:44:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55385 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967496Ab2EPNoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:44:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the staging tree
Date: Wed, 16 May 2012 13:41:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
References: <20120516185812.ce1ab57c3ec72445135a35fc@canb.auug.org.au> <201205161303.35080.arnd@arndb.de> <20120516131021.GA32351@kroah.com>
In-Reply-To: <20120516131021.GA32351@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205161341.47440.arnd@arndb.de>
X-Provags-ID: V02:K0:ORUIfwmMxb61BDXFiTpmj7DRmR0ubUdPuVqtiQppgtT
 oGw2VsRF65OA+P0grb4C+B5zKo+WJiZqTwuAZyKnMsHmy5jVB6
 jkdX3Uis+3C1brhHWoix2oj4GdYWxA6sEQrYlLuuPi6M+oN6Bv
 3BJgowNgsA4AMXKHQIfrxVCpP68IRe8ZfhtjBF6Nj4blRwqCam
 rm01wReXJMxYN1IqGYQEm3cK9kNXER9ks6VHhjMKgi+nMj1FRj
 W7WYrVe7FnIMNtI5rfA5CcxjDJKjg0xFJHNdAEXjynn/L2QUGj
 PfMGLny+Z3yQeUfEfnXsK/7f4v8BurPLwZNycOZRM1FKxGVRCw
 //KBag/CR+j4a78amSUc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2012, Greg KH wrote:
> On Wed, May 16, 2012 at 01:03:34PM +0000, Arnd Bergmann wrote:
> > The staging tree version adds contents to at91sam9g20.dtsi, and the context
> > gets moved to at91sam9260.dtsi in arm-soc. If we want to resolve it now,
> > I think the best way is to add the change to at91sam9260.dtsi in arm-soc
> > and let you drop that part in staging. There are no hard dependencies
> > since this is new code and it the driver is still correct without the
> > change, it simply won't find the device.
> 
> Ok, so if we leave it as-is for now, we can resolve it after 3.5-rc1 is
> out and we see what branch ended up "winning"?  :)

Yes, works for me.

	Arnd
