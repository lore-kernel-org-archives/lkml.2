Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab2JWIxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:53:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63340 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520Ab2JWIxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:53:19 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/32 v4] MIPS: Loongson 1B: use ehci-platform instead of ehci-ls1x.
Date: Tue, 23 Oct 2012 01:53:17 -0700 (PDT)
Message-ID: <10090450.q3VbTvBDPg@flexo>
Organization: OpenWrt
User-Agent: KMail/4.8.5 (Linux/3.2.0-24-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <36521520.iGJ91Agxac@flexo>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org> <CAJhJPsV5mFmOgU38ZpnYqUTNuOPmvRXjsf31XdFUqNOzsd_Edg@mail.gmail.com> <36521520.iGJ91Agxac@flexo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2012 10:46:50 Florian Fainelli wrote:
> Hi Kelvin,
> 
> On Tuesday 23 October 2012 16:13:01 Kelvin Cheung wrote:
> > Thank Florian.
> > It looks great.
> > However, you forget to remove corresponding section in
> > drivers/usb/host/ehci-hcd.c
> > ...
> > #ifdef CONFIG_MACH_LOONGSON1
> > #include "ehci-ls1x.c"
> > #define PLATFORM_DRIVER         ehci_ls1x_driver
> > #endif
> 
> Indeed, my bad I will follow up with some fixes for this patchset anyway.
> Thank you!

Looks like I hit reply too quickly, the patch entitled
"USB: EHCI: remove Loongson 1B EHCI driver" actually removes this bit from
ehci-hcd.c.
--
Florian
