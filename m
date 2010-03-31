Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab0CaJkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 05:40:07 -0400
Received: from mailgw01.datarespons.com ([81.0.189.39]:4728 "EHLO
	mailgw01.datarespons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab0CaJkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:40:04 -0400
Date: Wed, 31 Mar 2010 11:39:56 +0200
From: Anders Darander <anders.darander@datarespons.se>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       Erik Waling <erik.waling@konftel.com>,
       Patrick McHardy <kaber@trash.net>,
       Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] MACB: Set PHY address in kernel parameters
Message-ID: <20100331093956.GI4837@datarespons.se>
References: <1270025218-7245-1-git-send-email-anders.darander@gmail.com>
 <4BB31345.5050101@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB31345.5050101@pengutronix.de>
X-Accept-Language: sv, en, de
X-GPG-Fingerprint: A8FE 0294 BA4B 6981 DD9A  2900 C5C7 016C B47B AE60
X-GPG-Key-Id: 0xB47BAE60
X-GPG-Keyserver: hkp://keys.gnupg.net
Organization: Data Respons AB
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 31 Mar 2010 09:39:57.0274 (UTC) FILETIME=[1FFC63A0:01CAD0B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marc Kleine-Budde <mkl@pengutronix.de> [100331 11:18]:
> We're using phy_mask in one of our projects, it's still using 2.6.29,
> though. I think it's worth testing if it's still working.

Well, that was obviously something I overlooked / misinterpreted when I
tried to solve our problem!

As I understand it, phy_mask is a bitfield for setting which PHYs should
be enabled... Then this should have worked OK for us!

> static struct at91_eth_data __initdata p298_macb_data = {
>        .is_rmii        = 0,
>        .phy_mask       = ~(1 << 8),
> };

> at91_add_device_eth(&p298_macb_data);

I've not tested it, but it should probably have worked.

Regards,
Anders

