Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab2KJDtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 22:49:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40661 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab2KJDtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 22:49:11 -0500
Date: Fri, 09 Nov 2012 22:49:09 -0500 (EST)
Message-Id: <20121109.224909.1450759513114986795.davem@davemloft.net>
To: andreas@gaisler.com
Cc: sam@ravnborg.org, sparclinux@vger.kernel.org, software@gaisler.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] of/address: sparc: Declare of_address_to_resource()
 as an extern function for sparc again
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352112798-26307-1-git-send-email-andreas@gaisler.com>
References: <50979310.9010902@gaisler.com>
	<1352112798-26307-1-git-send-email-andreas@gaisler.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>
Date: Mon,  5 Nov 2012 11:53:18 +0100

> This bug-fix makes sure that of_address_to_resource is defined extern for sparc
> so that the sparc-specific implementation of of_address_to_resource() is once
> again used when including include/linux/of_address.h in a sparc context. A
> number of drivers in mainline relies on this function working for sparc.
> 
> The bug was introduced in a850a7554442f08d3e910c6eeb4ee216868dda1e, "of/address:
> add empty static inlines for !CONFIG_OF". Contrary to that commit title, the
> static inlines are added for !CONFIG_OF_ADRESS, and CONFIG_OF_ADRESS is never
> defined for sparc. This is good behavior for the other functions in
> include/linux/of_address.h, as the extern functions defined in
> drivers/of/address.c only gets linked when OF_ADDRESS is configured. However,
> for of_address_to_resource is that there exists a sparc-specific implementation
> in arch/sparc/arch/sparc/kernel/of_device_common.c
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Applied.
