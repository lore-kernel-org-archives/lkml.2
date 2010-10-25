Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0JYJHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:07:07 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57926 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0JYJHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:07:05 -0400
Date: Mon, 25 Oct 2010 11:09:23 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH v6] USB device driver of Topcliff PCH
In-reply-to: <4CC53D2D.7070309@dsn.okisemi.com>
To: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Message-id: <op.vk4jpxyt7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <4CC53D2D.7070309@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 10:17:49 +0200, Toshiharu Okada <toshiharu-linux@dsn.okisemi.com> wrote:
> This driver AUTHOR was changed to "Toshiharu Okada" from "Masayuki Ohtake".
> We updated the Kconfig and Makefile, renamed "Topcliff" to "EG20T".
>
> This patch had not been added to the Linus's kernel tree yet after your "Acked-by".
> Do we need other actions in order to add this driver to the Linus's kernel tree.

I'm in no power of deciding what gets accepted or rejected.  My Acked-by only meant
that after looking at the code a few times, I saw no obvious problems with the patch.
If you wish for this patch to be included you should send it to or at least cc
"Greg Kroah-Hartman" <gregkh@suse.de>.


> +static int __init pch_udc_pci_init(void)
> +{
> +	return pci_register_driver(&pch_udc_driver);
> +}
> +module_init(pch_udc_pci_init);
> +
> +static void __exit pch_udc_pci_exit(void)
> +{
> +	pci_unregister_driver(&pch_udc_driver);
> +}
> +module_exit(pch_udc_pci_exit);
> +
> +MODULE_DESCRIPTION("OKI SEMICONDUCTOR PCH USB Device Controller");
> +MODULE_AUTHOR("OKI SEMICONDUCTOR, <toshiharu-linux@dsn.okisemi.com>");
> +MODULE_LICENSE("GPL");
> +

Also, emtpy line at the end of file.  If you're going to resend the patch,
please remove the line.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
