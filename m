Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0GWFun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:50:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58111
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab0GWFul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:50:41 -0400
Date: Thu, 22 Jul 2010 22:50:58 -0700 (PDT)
Message-Id: <20100722.225058.178805105.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 1/4] of/device: Replace of_device with platform_device
 in includes and core code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100722223006.21557.84275.stgit@angua>
References: <20100722222600.21557.34167.stgit@angua>
	<20100722223006.21557.84275.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 22 Jul 2010 16:30:06 -0600

> of_device is currently just an #define alias to platform_device until it
> gets removed entirely.  This patch removes references to it from the
> include directories and the core drivers/of code.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>
