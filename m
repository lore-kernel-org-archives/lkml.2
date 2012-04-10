Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2DJPVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:21:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50344 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab2DJPVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:21:05 -0400
MIME-Version: 1.0
In-Reply-To: <1334066771-10458-1-git-send-email-svenkatr@ti.com>
References: <1334066771-10458-1-git-send-email-svenkatr@ti.com>
From: Santosh Y <santoshsy@gmail.com>
Date: Tue, 10 Apr 2012 20:50:42 +0530
Message-ID: <CALMYJDtQ8Dbwhyk0WKe7_Xk_40+3_c11U6bMJ-Li4XhUp7=-Pw@mail.gmail.com>
Subject: Re: [PATCH] scsi/ufs: use module_pci_driver
To: Venkatraman S <svenkatr@ti.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  drivers/scsi/ufs/ufshcd.c |   19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index cd59f6f..5ab9b3f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1952,24 +1952,7 @@ static struct pci_driver ufshcd_pci_driver = {
>  #endif
>  };
>
> -/**
> - * ufshcd_init - Driver registration routine
> - */
> -static int __init ufshcd_init(void)
> -{
> -       return pci_register_driver(&ufshcd_pci_driver);
> -}
> -module_init(ufshcd_init);
> -
> -/**
> - * ufshcd_exit - Driver exit clean-up routine
> - */
> -static void __exit ufshcd_exit(void)
> -{
> -       pci_unregister_driver(&ufshcd_pci_driver);
> -}
> -module_exit(ufshcd_exit);
> -
> +module_pci_driver(ufshcd_pci_driver);


Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
