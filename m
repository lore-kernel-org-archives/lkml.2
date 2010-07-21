Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab0GUSiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 14:38:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57215
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab0GUSiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 14:38:50 -0400
Date: Wed, 21 Jul 2010 11:39:06 -0700 (PDT)
Message-Id: <20100721.113906.102700682.davem@davemloft.net>
To: leedom@chelsio.com
Cc: shemminger@vyatta.com, andy@greyhouse.net, harald@redhat.com,
        bhutchings@solarflare.com, sassmann@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gospo@redhat.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network
 interfaces with random MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <201007211129.48288.leedom@chelsio.com>
References: <20100721102816.4bef5ada@nehalam>
	<20100721.103249.107094774.davem@davemloft.net>
	<201007211129.48288.leedom@chelsio.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Leedom <leedom@chelsio.com>
Date: Wed, 21 Jul 2010 11:29:47 -0700

>   Another option might be to have a new Net Device Operations call to ask the 
> adapter for a Unique Key.  This could be formed for most devices via a tuple of 
> the {PCI Vendor ID, PCI Device ID, Adapter Serial Number, Port Number, [and if 
> applicable] Adapter Function ID}.  Of course this could be a fairly long string 
> ... :-)

If a unique key were available, it could be used to generate a persistent
MAC address.

And this sort of means that these drivers could use bits of the
device's geographic ID the construct persistent MAC addresses, but
only if done in a MAC namespace that could be guarenteed unique on the
local system.

