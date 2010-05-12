Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0ELKil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:38:41 -0400
Received: from mail142.messagelabs.com ([216.82.249.99]:24803 "EHLO
	mail142.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0ELKii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:38:38 -0400
X-VirusChecked: Checked
X-Env-Sender: Viral.Mehta@lntinfotech.com
X-Msg-Ref: server-9.tower-142.messagelabs.com!1273660714!61810252!1
X-StarScan-Version: 6.2.4; banners=lntinfotech.com,-,-
X-Originating-IP: [203.199.118.206]
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: =?iso-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 May 2010 16:07:38 +0530
Subject: RE: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
Thread-Topic: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
Thread-Index: AcrxvqGqZaUDDjQZTmqrOXA9LeY99QAAIKZc
Message-ID: <70376CA23424B34D86F1C7DE6B9973430254343AC0@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck4q0c87p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck63vc77p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABD@VSHINMSMBX01.vshodc.lntinfotech.com>,<op.vck8y0uv7p4s8u@pikus>
In-Reply-To: <op.vck8y0uv7p4s8u@pikus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>If luns allocation fails, common->luns will be NULL and freeing a NULL
>pointer is a no-operation thus the code works just fine.

Oh, okie.
This was new to me. Sorry for the noise.

--
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Micha³ "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

______________________________________________________________________

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
