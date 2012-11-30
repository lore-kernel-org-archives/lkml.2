Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031501Ab2K3Sna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:43:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45393 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031365Ab2K3Sn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:43:28 -0500
Date: Fri, 30 Nov 2012 13:43:26 -0500 (EST)
Message-Id: <20121130.134326.730429492162984746.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: casey@schaufler-ca.com, paul@paul-moore.com, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: Add missing depends on INET in Kconfig
From: David Miller <davem@davemloft.net>
In-Reply-To: <50B8EF79.4080907@xenotime.net>
References: <50B8E4E6.2040901@xenotime.net>
	<50B8ECB3.2090801@schaufler-ca.com>
	<50B8EF79.4080907@xenotime.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Fri, 30 Nov 2012 09:40:09 -0800

> On 11/30/2012 09:28 AM, Casey Schaufler wrote:
> 
>> Because NETLABEL depends on INET SECURITY_SMACK
>> has to explicitly call out the dependency.
>> 
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Thanks for the quick fix.

In what tree does this Kconfig file look like this?

In my net-next tree the current dependencies are expressed as:

	depends on NETLABEL && SECURITY_NETWORK
