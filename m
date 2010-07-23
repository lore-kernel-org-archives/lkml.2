Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab0GWFvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:51:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58126
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786Ab0GWFu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:50:58 -0400
Date: Thu, 22 Jul 2010 22:51:15 -0700 (PDT)
Message-Id: <20100722.225115.160202643.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 3/4] sparc: remove references to of_device and
 to_of_device
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100722223016.21557.40832.stgit@angua>
References: <20100722222600.21557.34167.stgit@angua>
	<20100722223016.21557.40832.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 22 Jul 2010 16:30:16 -0600

> of_device is just a #define alias to platform_device.  This patch
> replaces all references to it with platform_device.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>
