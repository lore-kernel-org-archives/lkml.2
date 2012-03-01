Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab2CAUnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:43:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60037 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab2CAUnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:43:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 6/8] ARM: tegra: USB_ULPI needs USB
Date: Thu, 1 Mar 2012 20:42:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alan Ott <alan@signal11.us>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <1330630010-11241-1-git-send-email-alan@signal11.us> <201203012025.53560.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF17BE861741@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BE861741@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203012042.51936.arnd@arndb.de>
X-Provags-ID: V02:K0:9E/ZJK4lUxYz0wYKG1De6CjaYmuQJYyLPrP7oHVu9fs
 n9uR0gVm+7p7TtRCBpoJ++uxbgHOFrbjCrGeoPzspAZRfPxyxG
 Kw+0n/Q6Z8mbkWzmy/wFL0eUTLDwD7ligm+INBuuUh1sTXagNo
 LDymInrnT5rO/xTx0SWxTuTolmu2ePiEb6Fj0fRg08uM7Jcqi+
 VNAkwb+BBKLAhh7V4nU82J2mWVZjO+zBhmWgKnCWevc9qhceez
 M3/Dd3uWzb8lGJLt2qMVgfBIwV89zQNmd2KWv8U06k/ZSM+u5Z
 z8CIdKwcGfs2uvZImP6WJW+k4Fc6FG2cLQMq3IHvGkcCK1emFI
 Q0HcMhxMc6D2siOxokxg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Stephen Warren wrote:
> > Or maybe just don't select
> > USB_ULPI to start with and put it into the defconfig instead.
> 
> Perhaps USB_EHCI_TEGRA should depend on USB, and select USB_EHCI?

I think it should, but that is a different issue. All EHCI bus
glues currently depend on USB_EHCI_HCD instead of selecting it.

Changing that would likely break a number of other things that
have come to depend on the current behavior.

	Arnd
