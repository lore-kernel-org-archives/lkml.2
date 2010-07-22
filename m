Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0GVF21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:28:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51056
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754341Ab0GVF2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:28:12 -0400
Date: Wed, 21 Jul 2010 22:28:28 -0700 (PDT)
Message-Id: <20100721.222828.116132078.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, benh@kernel.crashing.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/5] of: Merge of_platform_bus_type with
 platform_bus_type
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100721233959.7782.17711.stgit@angua>
References: <20100721232817.7782.23410.stgit@angua>
	<20100721233959.7782.17711.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Jul 2010 17:40:00 -0600

> of_platform_bus was being used in the same manner as the platform_bus.
> The only difference being that of_platform_bus devices are generated
> from data in the device tree, and platform_bus devices are usually
> statically allocated in platform code.  Having them separate causes
> the problem of device drivers having to be registered twice if it
> was possible for the same device to appear on either bus.
> 
> This patch removes of_platform_bus_type and registers all of_platform
> bus devices and drivers on the platform bus instead.  A previous patch
> made the of_device structure an alias for the platform_device structure,
> and a shim is used to adapt of_platform_drivers to the platform bus.
> 
> After all of of_platform_bus drivers are converted to be normal platform
> drivers, the shim code can be removed.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>
