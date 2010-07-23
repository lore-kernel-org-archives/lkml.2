Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297Ab0GWUDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:03:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54841
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258Ab0GWUDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:03:45 -0400
Date: Fri, 23 Jul 2010 13:04:02 -0700 (PDT)
Message-Id: <20100723.130402.232759717.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: jonas@southpole.se, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        benh@kernel.crashing.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] of: make of_find_device_by_node generic
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100723200217.18363.48627.stgit@angua>
References: <20100723200217.18363.48627.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 23 Jul 2010 14:02:17 -0600

> From: Jonas Bonn <jonas@southpole.se>
> 
> There's no need for this function to be architecture specific and all four
> architectures defining it had the same definition.  The function has been
> moved to drivers/of/platform.c.
> 
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> [grant.likely@secretlab.ca: moved to drivers/of/platform.c, simplified code, and added kerneldoc comment]
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>
