Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0GVF23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:28:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51069
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602Ab0GVF2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:28:19 -0400
Date: Wed, 21 Jul 2010 22:28:35 -0700 (PDT)
Message-Id: <20100721.222835.258899665.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, benh@kernel.crashing.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, sparclinux@vger.kernel.org
Subject: Re: [PATCH 3/5] of/platform: remove all of_bus_type and
 of_platform_bus_type references
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100721234005.7782.52867.stgit@angua>
References: <20100721232817.7782.23410.stgit@angua>
	<20100721234005.7782.52867.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Jul 2010 17:40:05 -0600

> Both of_bus_type and of_platform_bus_type are just #define aliases
> for the platform bus.  This patch removes all references to them and
> switches to the of_register_platform_driver()/of_unregister_platform_driver()
> API for registering.
> 
> Subsequent patches will convert each user of of_register_platform_driver()
> into plain platform_drivers without the of_platform_driver shim.  At which
> point the of_register_platform_driver()/of_unregister_platform_driver()
> functions can be removed.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>
