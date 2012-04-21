Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2DULqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:46:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60886 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2DULqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:46:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH] Defconfig update for LPC32xx
Date: Sat, 21 Apr 2012 11:46:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1335006394-26810-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1335006394-26810-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204211146.29929.arnd@arndb.de>
X-Provags-ID: V02:K0:Z9vCFIN3PuSQ8mqFvvhlqCc/4uLlGXU7OJjKfw4XL1V
 cNu4vfu5sFecoN+dkZkfrriXwzQWm+sfAZljSKA+h/2CON6Xw+
 SMSeFZd1rrre0bEEHcfqBLDjeBI0XjAPdM3Yhh4whpEuqxSOJU
 /yyzcxGUkhiRKMjPQ6C1LtpCDkyRPXdbfC4QvYqb2AB//vuH7D
 bNz/bAY/P0xunwWNGUFBL43Euz1HfhFCgVV/L2g42w4s99uOn1
 8nPSkS599BySRYnxl+tKYCa8QA/rhdl6GHflt6eXfpGZBDoW4Z
 20EQH5BSJcxkUo/fb88GC/jd9982NFl0dt1fr+mz7rI5xDKmoY
 QV98thombJUM+2haLxwY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2012, Roland Stigge wrote:
> This patch updates the defconfig for the LPC32xx SoC after device tree
> conversion:
> 
> * Adjustment to DT conversion, added new driver support
> * Added IPv6
> * Increased kernel log buffer
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 

Hi Roland,

I think the latest version of all of your patches is good, but I've
lost track of which ones you want to go through arm-soc. Can you send
me pull requests for each series you want applied on monday if you get
no more comments?

	Arnd
