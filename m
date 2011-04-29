Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab1D2L0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 07:26:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54325 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1D2L0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 07:26:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Date: Fri, 29 Apr 2011 13:26:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <201104212129.17013.arnd@arndb.de> <20110428093039.GU17290@n2100.arm.linux.org.uk> <1304024836.2513.198.camel@pasglop>
In-Reply-To: <1304024836.2513.198.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104291326.25634.arnd@arndb.de>
X-Provags-ID: V02:K0:QWgSHHY0ln/DRuvHVRTft89vCkT0dC1vCIgUEhvnHDl
 eeTh6BHolmeYhosY1I7i7CTdytCwijfzjH5hZwcngROi96zQ8A
 cEtf2j6O+NYjLlyQ742dwEFaI3LzbwHqLsrs/1c67idkDJtfAn
 duC5+cWnBUl3nPpVmsQymsEf/G+w1gHNvprkdnFctHQuRE/n48
 GscsE7d0vZJaNWFhQTrxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 April 2011, Benjamin Herrenschmidt wrote:
> > > 
> > > For PCI you can have the flag propagate from the PHB down, for busses
> > > without a bus type (platform) then whoever instanciate them (the
> > > platform code) can set that appropriately.
> > 
> > How can you do that when it changes mid-bus heirarchy?  I'm thinking
> > of the situation where the DRM stuff is on a child bus below the
> > root bus, and the root bus has DMA coherent devices on it but the DRM
> > stuff doesn't.
> 
> But that's not PCI right ? IE. with PCI, coherency is a property of the
> PHB... 

That is my understanding at least, but I'd like to have a confirmation
from the DRM folks.

I believe that the PC graphics cards that have noncoherent DMA mappings
are all of the unified memory (integrated into the northbridge) kind,
so they are not on the same host bridge as all regular PCI devices,
even if they appear as a PCI device.

	Arnd
