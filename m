Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab0CaGdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:33:19 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:49463 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab0CaGdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:33:17 -0400
MIME-Version: 1.0
In-Reply-To: <20100331055306.GC4837@datarespons.se>
References: <1269943112-6975-1-git-send-email-anders.darander@gmail.com> 
	<fa686aa41003300741x5ef9bdbpf56133304fe4d6e6@mail.gmail.com> 
	<20100331055306.GC4837@datarespons.se>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 31 Mar 2010 00:08:28 -0600
X-Google-Sender-Auth: 2d8f4502b2491675
Message-ID: <x2gfa686aa41003302308r8c4f84acy5ab0c7368313aa5@mail.gmail.com>
Subject: Re: [PATCH] Allow MACB to connect to a higher addresses PHY.
To: Anders Darander <anders.darander@datarespons.se>
Cc: "David S. Miller" <davem@davemloft.net>,
       Ralf Baechle <ralf@linux-mips.org>, Maxime Bizon <mbizon@freebox.fr>,
       David Daney <ddaney@caviumnetworks.com>, Sekhar Nori <nsekhar@ti.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andy Fleming <afleming@freescale.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 11:53 PM, Anders Darander
<anders.darander@datarespons.se> wrote:
> * Grant Likely <grant.likely@secretlab.ca> [100330 16:42]:
> One question, if I add such an kernel parameter, would it be OK to
> implement something like this in the macb-driver:
>
> if parameter == SOME_DEFAULT
>        phydev = phy_find_first(bp->mii_bus);
> else
>        phydev = bp->mii_bus->phy_map[parameter];
>
> I.e. if the parameter is set to some default value, the old behaviour is
> retained, otherwise the specified parameter is used for the phy_addr?

Absolutely.

g.
