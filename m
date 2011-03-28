Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1C1IaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:30:13 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:37162 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab1C1IaM (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:1>);
	Mon, 28 Mar 2011 04:30:12 -0400
Message-Id: <4D90E1C0020000230002A7D2@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 28 Mar 2011 02:30:08 -0600
From: "Joey Lee" <jlee@novell.com>
To: <axel.lin@gmail.com>
Cc: <airlied@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpu: poulsbo: Use PCI_VDEVICE macro
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2011-03-24 於 12:40 +0800，Axel Lin 提到：
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/gpu/stub/poulsbo.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/stub/poulsbo.c b/drivers/gpu/stub/poulsbo.c
> index 7edfd27..c7dfba9 100644
> --- a/drivers/gpu/stub/poulsbo.c
> +++ b/drivers/gpu/stub/poulsbo.c
> @@ -22,8 +22,8 @@ enum {
>  };
>  
>  static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
> -	{0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108}, \
> -	{0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109}, \
> +	{PCI_VDEVICE(INTEL, 0x8108), CHIP_PSB_8108}, \
> +	{PCI_VDEVICE(INTEL, 0x8109), CHIP_PSB_8109}, \
>  	{0, 0, 0}
>  };
>  

Acked-by: Lee, Chun-Yi <jlee@novell.com>


Good to me, thank's

Joey Lee

