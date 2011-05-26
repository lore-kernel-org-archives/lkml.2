Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab1EZVNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:13:16 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:43345 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238Ab1EZVNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:13:15 -0400
Message-ID: <4DDEC269.30808@msgid.tls.msk.ru>
Date: Fri, 27 May 2011 01:13:13 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: Linux USB list <linux-usb@vger.kernel.org>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: option driver, ZTE MF_330 matches linux usb 2.0 root hub
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that recently, all my systems started
loading option.ko driver even if I've no single
GSM modem anywhere around.

After some investigation I found this in option.c:

/* ZTE PRODUCTS -- alternate vendor ID */
#define ZTE_VENDOR_ID2                          0x1d6b
#define ZTE_PRODUCT_MF_330                      0x0002
...
        { USB_DEVICE(ZTE_VENDOR_ID2, ZTE_PRODUCT_MF_330) },


But this matches... "Linux Foundation 2.0 root hub",
which has this module alias:

  usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00

What are options to fix this option now? :)

Thanks!

[Cc'ing linux-kernel due to interesting USB ID clash]

/mjt
