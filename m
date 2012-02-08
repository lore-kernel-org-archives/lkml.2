Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab2BHTe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:34:57 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:10865 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755922Ab2BHTe4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:34:56 -0500
X-SpamScore: -13
X-BigFish: VS-13(zz9371I146fK1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: drivers/net/phy/phy.c issue
MIME-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
From: Andy Fleming <afleming@freescale.com>
In-Reply-To: <CACW_hTY41xZV6d0W2Z2kRfKOfa+RSQ-A-BoZsZwNXSQmeF_6Gg@mail.gmail.com>
Date: Wed, 8 Feb 2012 13:34:49 -0600
CC: <macro@linux-mips.org>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-ID: <7FDEBF4E-1566-4ADE-9B31-BE7497754F61@freescale.com>
References: <CACW_hTY41xZV6d0W2Z2kRfKOfa+RSQ-A-BoZsZwNXSQmeF_6Gg@mail.gmail.com>
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8, 2012, at 8:31 AM, Frans Meulenbroeks wrote:

> Hi
> 
> I found an issue with drivers/net/phy/phy.c
> As I could not identify a maintainer for this file I decided to mail
> it to the above addressees.
> Apologies upfront if it is inappropriate.
> 
> The issue:
> 
> My network interface was configured as 10Mbit, full duplex, autonegotiate off.
> If the cable is unplugged after 10 seconds or so the interface drops
> to half duplex and the message:
> Trying 10/HALF
> is printed. This message comes (if I am correct from the function
> phy_force_reduction in drivers/net/phy/phy.c
> 
> Maybe this is still ok, however if I reconnect my network cable the
> interface remains configured as 10 Mbit, half duplex.
> I had expected/assumed that it would go back to 10 Mbit, full duplex.
> 
> If I try the same with a 1Gbit full duplex link with autonegotiate on,
> the link also drops to half duplex whenever the cable is
> disconnected. However reconnecting the cable then brings the interface
> back to full duplex again.
> 
> Not sure what is wrong (if the interface should not be dropped to half
> or get back to full) and even less an idea how to fix it,
> but wanted to report it anyway, in the hope someone can shed a light
> on this and/or fix it.

What PHY are you using?


