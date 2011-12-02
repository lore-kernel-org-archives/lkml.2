Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab1LBPvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:51:23 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:7276 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1LBPvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:51:22 -0500
From: "Altobelli, David" <david.altobelli@hp.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jiri Slaby <jirislaby@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Brent Casavant <bcasavan@sgi.com>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Subject: RE: [PATCH] MISC: Convert to DEFINE_PCI_DEVICE_TABLE
Thread-Topic: [PATCH] MISC: Convert to DEFINE_PCI_DEVICE_TABLE
Thread-Index: AQHMsJ7vaXlch82gwkukN9Nu11XvRJXIsjHw
Date: Fri, 2 Dec 2011 15:50:41 +0000
Message-ID: <37C4B87385134E45B7F39B3000A56E9509248AEA@G4W3229.americas.hpqcorp.net>
References: <1322794977.25851.1.camel@phoenix>
In-Reply-To: <1322794977.25851.1.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.12]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB2FpS8N026416

-----Original Message-----
> From: Axel Lin 
> Subject: [PATCH] MISC: Convert to DEFINE_PCI_DEVICE_TABLE

> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables. Also convert to the PCI_DEVICE/PCI_VDEVICE macros for better
> readablity.

> drivers/misc/hpilo.c     |    2 +-
 
> diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
> index fffc227..f705cbb 100644
> --- a/drivers/misc/hpilo.c
> +++ b/drivers/misc/hpilo.c
> @@ -828,7 +828,7 @@ out:
>  	return error;
> }
 
> -static struct pci_device_id ilo_devices[] = {
> +static DEFINE_PCI_DEVICE_TABLE(ilo_devices) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB204) },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3307) },
> 	{ }

Acked-by: David Altobelli <david.altobelli@hp.com>

Thanks
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
