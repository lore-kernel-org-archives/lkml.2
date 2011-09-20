Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab1ITPr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:47:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60586 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1ITPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:47:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64 systems
Date: Tue, 20 Sep 2011 17:47:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, x86@kernel.org,
        SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Willy Lambert <lambert.willy@gmail.com>
References: <4E731565.5050307@grandegger.com> <63081.1316200771@turing-police.cc.vt.edu> <4E73A419.70907@grandegger.com>
In-Reply-To: <4E73A419.70907@grandegger.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109201747.50130.arnd@arndb.de>
X-Provags-ID: V02:K0:hJh6odGvaBXN/6ZEPacZ43NiTZsN7b/y4JOr/si/1mL
 FkH8p5GbEXM5UDn5hzR+m990B0OXQussBDUcZ3ay5W+mHS1LdG
 jI95PDLF8yzKasmC+5WSoleu4spu6la/gdrty4AR/rD6La6RTi
 vBpF8nybw9BVKmFNFVtDDc23zCsMJKJVFxhHgnKwWGatmi4Umd
 xhr9RN7jjwOht8JRFrR0JKZXWZAuoqxzgoWyX9+7KeuayizeUf
 Zo7ioIqQyPr/as9Fn4Jj2CVyqjoXkhMuRoQUwEbrEwwbsPcGIV
 6R4PXh3WPtV7wQYkuX27wgoeCy/ZP0Brbe/2cFmU96ZQH7qaXZ
 GPoKReuEerH02jCJRouM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 September 2011, Wolfgang Grandegger wrote:
> On 09/16/2011 09:19 PM, Valdis.Kletnieks@vt.edu wrote:
> > On Fri, 16 Sep 2011 11:22:45 +0200, Wolfgang Grandegger said:
> >> There are 64-bit systems out there, like the ATOM N450, which
> >> have ISA slots.
> > 
> > That's a scary thought...
> 
> Well. Actually we need it for Intel Atom N450 PC/104-Plus SBCs.

I would assume that you have a small set of ISA add-on cards that
you actually need to support, right?

Since most ISA drivers don't actually use isa_register_driver
(for good or bad), how about changing the Kconfig entry for
the ones you need to 'depends on ISA || PLAT_GRANDEGGER_PC104_ATOM'
or similar?

	Arnd
