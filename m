Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab2KIWDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:03:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38805 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2KIWD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:03:27 -0500
Date: Fri, 09 Nov 2012 17:03:25 -0500 (EST)
Message-Id: <20121109.170325.1980537042704002051.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: sasha.levin@oracle.com, pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmxnet3: convert BUG_ON(true) into a simple BUG()
From: David Miller <davem@davemloft.net>
In-Reply-To: <967392202.19635700.1352440936686.JavaMail.root@vmware.com>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
	<967392202.19635700.1352440936686.JavaMail.root@vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Thu, 8 Nov 2012 22:02:16 -0800 (PST)

> 
> ----- Original Message -----
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> ---
>>  drivers/net/vmxnet3/vmxnet3_drv.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Signed-off-by: Shreyas N Bhatewara <sbhatewara@vmware.com>

Applied, thanks.
