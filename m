Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1G1Ixl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 04:53:41 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41583 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750734Ab1G1Ixc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 04:53:32 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: hostap_cs: add ID for LG cards
Date: Thu, 28 Jul 2011 10:53:27 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201107262314.03422.linux@rainbow-software.org> <201107272219.23501.linux@rainbow-software.org> <4E308D11.8070405@gnu.org>
In-Reply-To: <4E308D11.8070405@gnu.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107281053.27521.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 July 2011, Pavel Roskin wrote:
> On 07/27/2011 04:19 PM, Ondrej Zary wrote:
> > On Tuesday 26 July 2011 23:54:37 Pavel Roskin wrote:
> >> I think we may want to introduce PCMCIA_DEVICE_MANF_CARD_PROD_ID3 and
> >> match
> >>
> >> PCMCIA_DEVICE_MANF_CARD_PROD_ID3(0x0156, 0x0002, "Version 1.02", xxx)
> >>
> >> Maybe some other card would be supported too?  I doubt there are any
> >> Agere or Symbol cards with "Version 1.02" in the third text ID.
> >
> > Yes, that looks good, it would match my card too:
> >    product info: "LG", "11Mbps Wireless LAN PCI Card", "Version 01.02",
> > "" manfid: 0x0156, 0x0002
> >    function: 6 (network)
>
> Good to know.
>
> > ---------------------------
> >
> > Add generic "Version 01.02" match (used by many different cards) to
> > hostap_cs.
> >
> > This allows LG LW1100P PCI card (with integrated CardBus bridge) to work
> > (tested with rev 3.0) and probably also LW1100N (PCMCIA).
> >
> > Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
>
> That's not the right way to submit patches.  Anyway, I sent 3 patches to
> that effect yesterday.  One in for PCMCIA, the second is for hostap_cs
> and the third is for orinoco_cs to recognize "Version 01.01" as Agere
> firmware and to stop claiming 0x0156:0x0002 unconditionally.

Thanks, I've missed your patches.

> I have no idea how interdependent series of patches that touch more than
> one subsystem are applied, but I guess there is a standard way.

-- 
Ondrej Zary
