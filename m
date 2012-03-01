Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966203Ab2CAM1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:27:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36808 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966134Ab2CAM1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:27:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.180.82.132 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Message-ID: <1330604856.2465.44.camel@edumazet-laptop>
Subject: Re: [PATCH 2/3] atl1c: change author
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cloud Ren <cjren@qca.qualcomm.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com
Date: Thu, 01 Mar 2012 04:27:36 -0800
In-Reply-To: <1330580469-23348-3-git-send-email-cjren@qca.qualcomm.com>
References: <1330580469-23348-1-git-send-email-cjren@qca.qualcomm.com>
	 <1330580469-23348-3-git-send-email-cjren@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 01 mars 2012 à 13:41 +0800, Cloud Ren a écrit :
> The author, jie yang, has left. please use nic-devel@qualcomm.com report bugs to
> us.
> 
> Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 6bf387b..815f683 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -52,7 +52,7 @@ static DEFINE_PCI_DEVICE_TABLE(atl1c_pci_tbl) = {
>  };
>  MODULE_DEVICE_TABLE(pci, atl1c_pci_tbl);
>  
> -MODULE_AUTHOR("Jie Yang <jie.yang@atheros.com>");
> +MODULE_AUTHOR("Qualcomm Corporation, <nic-devel@qualcomm.com>");
>  MODULE_DESCRIPTION("Atheros 1000M Ethernet Network Driver");
>  MODULE_LICENSE("GPL");
>  

Jie Yang, _is_ the original author. Thats a truth.

Why would you want to remove this line, this sounds very bad.

What you probably want is a change in MAINTAINERS file to reflect who
maintains atl1c at this moment and how to reach them by email.

Notes:

- Its also possible to add a new MODULE_AUTHOR() line

- You could remove the obsolete email address and keep Jie Yang name as
in :

MODULE_AUTHOR("Jie Yang");



