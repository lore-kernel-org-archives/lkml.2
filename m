Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab0FPVG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:06:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60799
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932220Ab0FPVG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:06:26 -0400
Date: Wed, 16 Jun 2010 14:06:38 -0700 (PDT)
Message-Id: <20100616.140638.115932212.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sparclinux@vger.kernel.org, sfr@canb.auug.org.au,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sparc/of: Move of_device fields into struct
 pdev_archdata
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100604211132.2762.54164.stgit@angua>
References: <20100604205930.2762.17131.stgit@angua>
	<20100604211132.2762.54164.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 04 Jun 2010 15:11:33 -0600

> This patch moves SPARC architecture specific data members out of
> struct of_device and into the pdev_archdata structure.  The reason
> for this change is to unify the struct of_device definition amongst
> all the architectures.  It also remvoes the .sysdata, .slot, .portid
> and .clock_freq properties because they aren't actually used by
> anything.
> 
> A subsequent patch will replace struct of_device entirely with struct
> platform_device and the of_platform support code will share common
> routines with the platform bus (but the bus instances themselves can
> remain separate).
> 
> This patch also adds 'struct resources *resource' and num_resources
> to match the fields defined in struct platform_device.  After this
> change, 'struct platform_device' can be used as a drop-in replacement
> for 'struct of_platform'.
> 
> This change is in preparation for merging the of_platform_bus_type
> with the platform_bus_type.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>
