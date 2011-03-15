Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1COJG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:06:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51536 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab1COJG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:06:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Tue, 15 Mar 2011 10:06:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: matti.j.aaltonen@nokia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103141801.01333.arnd@arndb.de> <99B09243E1A5DA4898CDD8B7001114481082FAE39E@EXMB04.eu.tieto.com>
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481082FAE39E@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151006.53558.arnd@arndb.de>
X-Provags-ID: V02:K0:rfdd81GHq1g7+tFdoa031Abao6oBkRuTXBwcJvK++gU
 BhOlA0vTdOo6Vat1YGBVmNG9Hmql1Vkj+rQGMjsLukiMw/Y/PD
 Zm2i59L+lCRrfOuWoCQOT4/8E2krIMJUXWY2hWcOvpOFX3CUwy
 QoQiyZfo2+jV4xryOQ4fw/TBRbnCy/Mbld596rYkC7eeBlIiz/
 w/DmunRhQYukxwvAmtNTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 March 2011 09:37:04 Waldemar.Rymarkiewicz@tieto.com wrote:
> >It sounds strange that this will be handled in user space, 
> >since it won't have any idea if the hardware is available again.
> 
> >I've tried to find the onfc stack that talks to this device 
> >but couldn't see it. Do you have a URL for this?
> 
> Here you are
> 
> http://sourceforge.net/projects/open-nfc/
> http://www.open-nfc.org

I found these before, but I did not find code that opens your
device to read or write it. There is a .zip file with some
source code, but that seems to have no connection to your
driver and no build instructions.

	Arnd
