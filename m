Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2KPReD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:34:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57748 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab2KPReA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:34:00 -0500
Date: Fri, 16 Nov 2012 12:33:58 -0500 (EST)
Message-Id: <20121116.123358.444599559940168490.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org, benh@kernel.crashing.org,
        julian.calaby@gmail.com
Subject: Re: [PATCH v2] drivers/of: Constify device_node->name and
 ->path_component_name
From: David Miller <davem@davemloft.net>
In-Reply-To: <1353075625-7755-1-git-send-email-grant.likely@secretlab.ca>
References: <1353075625-7755-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 16 Nov 2012 14:20:25 +0000

> Neither of these should ever be changed once set. Make them const and
> fix up the users that try to modify it in-place. In one case
> kmalloc+memcpy is replaced with kstrdup() to avoid modifying the string.
> 
> Build tested with defconfigs on ARM, PowerPC, Sparc, MIPS, x86 among
> others.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>
