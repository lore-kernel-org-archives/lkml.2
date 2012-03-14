Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186Ab2CNRKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:10:52 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:43796
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759325Ab2CNRKu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:10:50 -0400
X-SpamScore: -14
X-BigFish: PS-14(zz9371I542M1432N1a09Jzz1202hzz8275ch8275bh8275dhz2fh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:157.55.61.13;KIP:(null);UIP:(null);IPV:NLI;H:CH1PRD0802HT002.namprd08.prod.outlook.com;RD:none;EFVD:NLI
From: Chris Kelly <ckelly@ozmodevices.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: RE: [PATCH -next] staging: ozwpan depends on NET
Thread-Topic: [PATCH -next] staging: ozwpan depends on NET
Thread-Index: AQHNAgRJj/ZBmLwYI0C6mN+zNcGGFZZqBp4w
Date: Wed, 14 Mar 2012 17:10:44 +0000
Message-ID: <57C28D85C66F5C49B9E212CBFAFDAC1F2AB8D287@CH1PRD0802MB120.namprd08.prod.outlook.com>
References: <20120314181921.59451eca117c276461f7dc28@canb.auug.org.au>
 <4F60CF2F.5050505@xenotime.net>
In-Reply-To: <4F60CF2F.5050505@xenotime.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.42.110.7]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Agreed - many thanks for this.

Chris Kelly

-----Original Message-----
>From: Randy Dunlap [mailto:rdunlap@xenotime.net] 
>Sent: 14 March 2012 5:03 PM
>To: Stephen Rothwell
>Cc: linux-next@vger.kernel.org; LKML; Chris Kelly; Greg Kroah-Hartman; devel@driverdev.osuosl.org
>Subject: [PATCH -next] staging: ozwpan depends on NET

>From: Randy Dunlap <rdunlap@xenotime.net>

>Fix build errors:  add depends on NET.

>ERROR: "skb_clone" [drivers/staging/ozwpan/ozwpan.ko] undefined!
>ERROR: "dev_get_by_name" [drivers/staging/ozwpan/ozwpan.ko] undefined!
>ERROR: "dev_remove_pack" [drivers/staging/ozwpan/ozwpan.ko] undefined!
>ERROR: "init_net" [drivers/staging/ozwpan/ozwpan.ko] undefined!
>ERROR: "__alloc_skb" [drivers/staging/ozwpan/ozwpan.ko] undefined!
>ERROR: "kfree_skb" [drivers/staging/ozwpan/ozwpan.ko] undefined!
>ERROR: "dev_add_pack" [drivers/staging/ozwpan/ozwpan.ko] undefined!
>ERROR: "consume_skb" [drivers/staging/ozwpan/ozwpan.ko] undefined!
>ERROR: "dev_queue_xmit" [drivers/staging/ozwpan/ozwpan.ko] undefined!
>ERROR: "skb_put" [drivers/staging/ozwpan/ozwpan.ko] undefined!

>Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: Chris Kelly <ckelly@ozmodevices.com>

>Cc: Chris Kelly <ckelly@ozmodevices.com>
>Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>---
> drivers/staging/ozwpan/Kconfig |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

>--- linux-next-20120314.orig/drivers/staging/ozwpan/Kconfig
>+++ linux-next-20120314/drivers/staging/ozwpan/Kconfig
>@@ -1,6 +1,6 @@
> config USB_WPAN_HCD
> 	tristate "USB over WiFi Host Controller"
>-	depends on USB
>+	depends on USB && NET
> 	help
> 	  A driver for USB Host Controllers that are compatible with
> 	  Ozmo Devices USB over WiFi technology.

