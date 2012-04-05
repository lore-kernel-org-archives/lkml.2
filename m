Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2DERoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 13:44:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63004 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab2DERoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:44:14 -0400
MIME-Version: 1.0
X-Originating-IP: [50.1.53.18]
In-Reply-To: <4F7C7EDF.4000702@atmel.com>
References: <4F7C7EDF.4000702@atmel.com>
Date: Thu, 5 Apr 2012 10:44:13 -0700
Message-ID: <CAOesGMiEBBiZ1Q3RjT=KxCR+kJWhoVPGdMRFPN=nObjZuvzgWg@mail.gmail.com>
Subject: Re: [GIT PULL] at91: 3.4-rc1 fixes
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 10:03 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Arnd, Olof,
>
> I would like you to integrate this fist batch of AT91 related fixes. They
> are covering DT and USB related issues that we have seen on top of 3.4-rc1.
>
> I have also included modifications of the OHCI USB driver because they
> are also touching the core AT91 devices/board files and Device Tree files.
> The modification of "vbus_pin_active_low" in particular cannot be separated
> from the modification of .dts[i] and devices/board files.
>
> Alan Stern for USB OHCI/EHCI and Grant Likely for DT gave me their "Acked-by"
> on concerned patches (thanks a lot guys!).
>
> The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:
>
>  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)
>
> are available in the git repository at:
>
>  git://github.com/at91linux/linux-at91.git at91-fixes

Thanks, pulled.


-Olof
