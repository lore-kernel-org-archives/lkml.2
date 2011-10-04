Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab1JDHoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:44:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab1JDHoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:44:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 26/30] ARM: omap: add board autoselection
Date: Tue, 4 Oct 2011 09:44:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <5055144.Y0IUdMEWXQ@wuerfel> <20111003182649.GC6324@atomide.com>
In-Reply-To: <20111003182649.GC6324@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110040944.13205.arnd@arndb.de>
X-Provags-ID: V02:K0:9tMHlZXv+7UCSX49znCi9xRVvUl95fcv5NroHzz6yEk
 FCIQW/iK0gWvmxiooBkVvz33G4i3b8GzEV3hBG+YJwXalIB3lx
 VKl3osw4qLedlHg9heI77F8omTw9bAgZXoLzIMQm5s4w7N0/mo
 WjvndUK9H7FyTpUo0sbXM6BKXCIK1GxMkpsAOtd+Piu3aqSEA7
 ZkkSurVbSN6gBgUdZluvqF/PMQbwq6QQISeIPgI0DPpkFwjWd6
 gvfp0CmP/R94IPY+HWOjDBdwYoNC09Ak08TxWaF9RbkFaQkENJ
 J1p+j9uZrjse+GokLetkL3/sI8yfmiErDK89gqD619YfElb9fq
 Jxr/BWzXlqDQsRGfvlog=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011, Tony Lindgren wrote:
> * Arnd Bergmann <arnd@arndb.de> [111003 02:20]:
> > On Monday 03 October 2011 11:27:44 Cousson, Benoit wrote:
> > > >
> > > > In the long run, I'd hope we can just get rid of these for subarchitectures
> > > > that support device tree probing and make the device tree based machine
> > > > description unconditional.
> > > 
> > > This is really our goal, we will have soon the board-generic.c for that, 
> > > someone will just have to migrate these ~30 board files to device tree 
> > > DTS files 
> > 
> > For the purpose of build-time validation using randconfig, there is no
> > problem in keeping some board files forever, as long as the generic board
> > file is always built-in.
> 
> Yes please leave out the list so we don't need to constantly update it.
> Let's just always build in MACH_OMAP_GENERIC.

That's what I had initially, but now that board file has become
omap2-specific and no longer works on omap3-only or omap4-only
configurations.

	Arnd
