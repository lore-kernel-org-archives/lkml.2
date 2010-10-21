Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab0JUMCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:02:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab0JUMCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:02:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
Date: Thu, 21 Oct 2010 14:02:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com> <201010211104.28555.arnd@arndb.de> <AANLkTimWG_38hY2Xq=G7r42eP+zmA24Gaw4-hLVJstVA@mail.gmail.com>
In-Reply-To: <AANLkTimWG_38hY2Xq=G7r42eP+zmA24Gaw4-hLVJstVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211402.40272.arnd@arndb.de>
X-Provags-ID: V02:K0:99YarNVZuiiIdxcCfVn+OgBQlFHR+Cmf1dVzjewUKY8
 G2jchyKGoo4pqCsng5A3g+puJB/XrhLKleylxXhVDONGKJOI6T
 Bwh8BglR5ZwCy22nhFAE7pRuaB8fDuqHZ5YCmaQyBSelBmb0Ai
 J9QK3jAqOocT3S98nVlhwt21L/gggdhjnCS+rSamVewC2Z4Dvj
 Iun+H8qP8uYss+xT4RtPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 October 2010, Ohad Ben-Cohen wrote:
> The change is also pretty trivial:
> 
> * move the internal locking implementation to raw_ methods
> * the raw_ methods would save the current interrupt state only if
> given a placeholder
> * wrap those raw_ methods with the desired API (but only support the
> _irq and _irqsave flavors)
> 

Sounds good!

	Arnd
