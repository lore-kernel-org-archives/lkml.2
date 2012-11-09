Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2KIGCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 01:02:20 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:44236 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805Ab2KIGCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 01:02:17 -0500
Date: Thu, 8 Nov 2012 22:02:16 -0800 (PST)
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "VMware, Inc." <pv-drivers@vmware.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <967392202.19635700.1352440936686.JavaMail.root@vmware.com>
In-Reply-To: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
Subject: Re: [PATCH] vmxnet3: convert BUG_ON(true) into a simple BUG()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message -----
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Signed-off-by: Shreyas N Bhatewara <sbhatewara@vmware.com>
