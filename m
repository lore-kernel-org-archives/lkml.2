Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab0EYLIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:08:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41587 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab0EYLIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GDytczraX8TgxYxmIvKHxZ1fMdmytz4B9aDXBvzJwTirWJ5w1usTK0FqgBDR0ChVL1
         asYMXDrn1tLF+WHZe5a3IOQmUXtI7wXYQrwfQWEyiaEBcAak6Yo8OaWg/lU3qiS0/1ir
         dka6iIqT44vkqdEs9lD6IR0EUM7Cr3ALqjJN8=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz>
References: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz>
Date: Tue, 25 May 2010 20:08:12 +0900
Message-ID: <AANLkTikOFfTERKE-Wgw_9U9-3z0ecPZ-eWn_hjsU3M2h@mail.gmail.com>
Subject: Re: [PATCH] staging: remove all code dependent on LINUX_VERSION_CODE
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4PB8PaS004657

On Tue, May 25, 2010 at 7:01 PM, Jiri Kosina <jkosina@suse.cz> wrote:> diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c> index 4c86102..c52ff7c 100644> --- a/drivers/staging/cxt1e1/hwprobe.c> +++ b/drivers/staging/cxt1e1/hwprobe.c> @@ -305,15 +305,9 @@ c4hw_attach_all (void)> Â  Â  error_flag = 0;> Â  Â  prep_hdw_info ();> Â  Â  /*** scan PCI bus for all possible boards */> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)> - Â  Â while ((pdev = pci_get_device (PCI_VENDOR_ID_CONEXANT,> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  PCI_DEVICE_ID_CN8474,> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  pdev)))> -#else> Â  Â  while ((pdev = pci_find_device (PCI_VENDOR_ID_CONEXANT,> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  PCI_DEVICE_ID_CN8474,> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  pdev)))> -#endif> Â  Â  {> Â  Â  Â  Â  if (c4_hdw_init (pdev, found))> Â  Â  Â  Â  Â  Â  found++;The other way round ?ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
