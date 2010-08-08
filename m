Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0HHIbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 04:31:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36746
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab0HHIbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 04:31:22 -0400
Date: Sun, 08 Aug 2010 01:31:41 -0700 (PDT)
Message-Id: <20100808.013141.267939698.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sparclinux@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/sparc: fix build regression from of_device changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100808071628.11437.93510.stgit@angua>
References: <20100808071628.11437.93510.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 08 Aug 2010 01:19:38 -0600

> Commit id 1636f8ac2b08410df4766449f7c86b912443cd99 (sparc/of: Move
> of_device fields into struct pdev_archdata) missed fixing up the
> n2_core.c and greth.c drivers.  This patch makes the required changes.
> 
> Reported-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> David, I've currently got this one in my next-devicetree branch.  You
> can either pick it up, or it can go out when I ask Linus to pull on
> Monday or Tuesday.

Please ask Linus to pull your copy, thanks Grant.
