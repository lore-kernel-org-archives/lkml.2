Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab1JTQeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:34:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1JTQeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:34:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: driver for Atmel true hardware random number generator
Date: Thu, 20 Oct 2011 18:31:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        herbert@gondor.hengli.com.au
References: <4E92BEE9.5090604@atmel.com> <4E9D92CD.6010008@atmel.com>
In-Reply-To: <4E9D92CD.6010008@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110201831.36246.arnd@arndb.de>
X-Provags-ID: V02:K0:N81ZCUd2Q2jE/eqtRnswo3ZZ5egOOm8slC+tGJ1KDxO
 qGtKupGpun+iG7R7ywpBulPwYatqVofsuYBrl7sTNrApAWc6e8
 fMiIuwbgV4ScLi4r8C9abmEDLDmytyrgrJXADhyyKM/u0Bzwxv
 NRJek62RVfwmx3gEvOFxHX5fINDpZlSjZTS/5gm078h9lR5pfF
 qEPVzalPeayqpuj5CFC4IZWMbMk39VAP7sWPQPvpn8arHtzL8C
 oCmAqiwM5v28FbCf72BUMPRk27pDL7uY0BKIzgpb9ErmymNr7b
 i4dZ6Wp1hK6av6YJUU9E4WR8QFbIALYycAtzFbfJ3zSCDEGgpU
 bpmNXzmS0DMMvOFBdmp4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 October 2011, Nicolas Ferre wrote:
> On 10/10/2011 11:46 AM, Nicolas Ferre :
> > Hi Arnd,
> > 
> > Here is a couple of patches for adding the True Random Number Generator
> > that can be find on some AT91SAM SoCs.
> > Herbert Xu told me that this material can go through the ARM SoC tree.
> 
> Ping?

I'm sorry I missed this at first. I've pulled it into the next/driver
branch now.

Thanks,

	Arnd
