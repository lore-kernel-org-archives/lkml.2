Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab0GUQhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 12:37:46 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:19341 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab0GUQho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 12:37:44 -0400
From: Casey Leedom <leedom@chelsio.com>
Organization: Chelsio Communications, Inc.
To: Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network interfaces with random MAC address
Date: Wed, 21 Jul 2010 09:34:27 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; x86_64; ; )
Cc: Harald Hoyer <harald@redhat.com>, David Miller <davem@davemloft.net>,
        shemminger@vyatta.com, bhutchings@solarflare.com, sassmann@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, gospo@redhat.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com
References: <20100720141816.16f0a939@nehalam> <4C469808.5060308@redhat.com> <20100721150732.GR7497@gospo.rdu.redhat.com>
In-Reply-To: <20100721150732.GR7497@gospo.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007210934.27986.leedom@chelsio.com>
X-OriginalArrivalTime: 21 Jul 2010 16:34:28.0743 (UTC) FILETIME=[96CD6170:01CB28F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| From: Andy Gospodarek <andy@greyhouse.net>
| Date: Wednesday, July 21, 2010 08:07 am
| 
| Agreed.  The subtle difference between a locally assigned address that
| is persistent and one that is random would be helpful.

  And just to point out that this case _does_ exist: the igb/igbvf drivers use 
random_ether_addr() to generate a random, locally assigned MAC address for the 
PCI-E SR-IOV Virtual Function MAC Addresses while the cxgb4/cxgb4vf drivers use 
a persistent, non-random locally assigned MAC Addresses.

  Note that I am neither arguing for nor against the proposal.  I'm just 
pointing out an existence case for the distinction.  And yes, bit 1 being set in 
the first octet of a MAC address for locally assigned MAC Addresses is part of 
the IEEE 802 specification just as bit 0 being set in the same octet indicates 
that it's a multi-station address.

Casey
