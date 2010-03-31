Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab0CaIud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:50:33 -0400
Received: from mailgw01.datarespons.com ([81.0.189.39]:4235 "EHLO
	mailgw01.datarespons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881Ab0CaIub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:50:31 -0400
Date: Wed, 31 Mar 2010 10:50:25 +0200
From: Anders Darander <anders.darander@datarespons.se>
To: Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MACB: Set PHY address in kernel parameters
Message-ID: <20100331085024.GG4837@datarespons.se>
References: <1270021902-6556-1-git-send-email-anders.darander@gmail.com>
 <4BB307CA.9080305@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB307CA.9080305@trash.net>
X-Accept-Language: sv, en, de
X-GPG-Fingerprint: A8FE 0294 BA4B 6981 DD9A  2900 C5C7 016C B47B AE60
X-GPG-Key-Id: 0xB47BAE60
X-GPG-Keyserver: hkp://keys.gnupg.net
Organization: Data Respons AB
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 31 Mar 2010 08:50:25.0712 (UTC) FILETIME=[34CC0300:01CAD0AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Patrick McHardy <kaber@trash.net> [100331 10:29]:
> Anders Darander wrote:
> > +	if (phy_addr >= PHY_MAX_ADDRESS)
> > +		phydev = phy_find_first(bp->mii_bus);
> > +	else
> > +		phydev = bp->mii_bus->phy_map[phy_addr];

> This looks like you need to use an unsigned to avoid negative
> indices.

Thanks for spotting this. That made me find that I'd also been inconsistent with the variable and module parameter declarations.

A new version, V2, of the patch has been sent.

Best regards,
Anders Darander

