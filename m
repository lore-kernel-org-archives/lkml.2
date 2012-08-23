Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab2HWMMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:12:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2HWMMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:12:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 2/6] ARM: omap: allow building omap44xx without SMP
Date: Thu, 23 Aug 2012 12:12:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de> <201208221722.06775.arnd@arndb.de> <CAMQu2gw_090MiWxs6m=5o0wQhL=ovmN1Y_7DUVhTbJU6mHPS5Q@mail.gmail.com>
In-Reply-To: <CAMQu2gw_090MiWxs6m=5o0wQhL=ovmN1Y_7DUVhTbJU6mHPS5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208231212.04869.arnd@arndb.de>
X-Provags-ID: V02:K0:3vixn4csy06Ssy2ypfy+ZauwIpFSrzmZilMAd4KD8oa
 oeHLQEUbrRIWsTHgRU7akx2vDFIHASrihZOlda6IZGCueGRz3b
 oJm8L7Q60pDRe9XVB+WmvlgG/LoJWkLhvgOavdMqzwueoFkryb
 Qo5y5QLFwXOCBLcgZzm+f9z+drG5uzpK61ScamBmrczpQXATxp
 kN1qsQD4Xrns7wHq+KkzO5zppoRn7UzDNCJZYBMevsXlA17/Lt
 u1pt1J4BK2F/BrHLBcrgB6Eh0k+U9CxkiNHfs6RLZP8RYrTFb3
 k/FGnnHqXM9GXFbzVPNBvlw1ZG5f/RmO57+fai3qpfK/GvYiq0
 IDfZv89LkEnsHiydWOfM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012, Shilimkar, Santosh wrote:
> I see your point but alternate patch is pushing down the fix to the low
> level driver and that means you end up patching more drivers when they
> use COUPLE idle infrastructure. That was the only reason I was thinking
> of suppressing the error at the source.
> 
> Since it is just for the random builds and actually doesn't impact the real
> functionality as such, I am fine with your proposed patch too.

Ok. It would be nice of course to test if this actually works on uniprocessor
configurations.

	Arnd
