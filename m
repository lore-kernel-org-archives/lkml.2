Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab2HWKf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:35:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab2HWKfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:35:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Devendra Naga <develkernel412222@gmail.com>
Subject: Re: [PATCH] misc: use module_spi_driver
Date: Thu, 23 Aug 2012 10:35:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <1345711989-23276-1-git-send-email-develkernel412222@gmail.com>
In-Reply-To: <1345711989-23276-1-git-send-email-develkernel412222@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208231035.51627.arnd@arndb.de>
X-Provags-ID: V02:K0:xptqiv8sMyO+r3AQbPWD6cNmc1u8SxxP9rCAIRCA5M3
 uvNNQJD5a7CA/+bPAM4kOl9i/I5sHXV23ygnwtJBCfigAw0ROw
 0lrNammHd4X4WzLtBMef/IqNSk4/sh7pLPIkLcHT9QUGUe7jf6
 J66Dg3NAH2Yd6ZvTr40YKJSM8fGkQYU0wtDUPVo57P1dslaRw6
 LyXWUrJjpYD0O5diQCznJjM3WUDB1S1hiu7N/jLtMQXVRKoTdi
 pOC0vS821Aayw6d+dnQdNPHOPkbbdyN3K6kOW1RpH07BzP+py7
 ojmYjYjD2Yh3u7sgNNrS1k8aF1u76QL0mo3dVjy14v7yw4SvrW
 ZAGD52iBWTn2VTS5U53w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012, Devendra Naga wrote:
> The _init and _exit functions can be replaced with the module_spi_driver
> macro, which actually implements
> 
> static int __init drv_init(void)
> {
>         spi_register_driver(&driv_op);
>         return 0;
> }
> 
> module_init(drv_init);
> 
> static void __exit drv_exit(void)
> {
>         spi_unregister_driver(&driv_op);
> }
> 
> module_exit(drv_exit);
> 
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
