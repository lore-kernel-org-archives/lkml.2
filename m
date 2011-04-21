Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1DUJEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:04:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57008 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab1DUJEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:04:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/3] bitops: add ifdef CONFIG_GENERIC_FIND_BIT_LE guard
Date: Thu, 21 Apr 2011 11:03:55 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
References: <1303309252-9946-1-git-send-email-akinobu.mita@gmail.com> <201104201631.40017.arnd@arndb.de> <BANLkTimBF312svk0mRkt5_Y=t+B12cLW+Q@mail.gmail.com>
In-Reply-To: <BANLkTimBF312svk0mRkt5_Y=t+B12cLW+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104211103.55929.arnd@arndb.de>
X-Provags-ID: V02:K0:Txo9GGJo/sXyHRbq9IqGEDK24GVOR5OdP/TiJ+jj1ku
 jrdue+STQF2n0g3SSEtZZVd0XU7OjaOyl6gsrBtWnvSSXODsPZ
 cvKCsUbkEb5g5K2poSNJDcwhEXKaJmkQoSIzNcSan7UZrWrRoV
 tWe/AcOuGBnmdlnVvrYFOkGaW8y9XkAOBnT2PehTZx3Z/0Vp2B
 SDe8mq7neOAkg/i4N4fjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 April 2011, Akinobu Mita wrote:
> Should we also kill CONFIG_GENERIC_FIND_BIT_LE option comletely,
> then add the #ifdef for each find_*() in lib/find_next_bit.c and always build
> it unconditionally ?

I think that would be more consistent. It's not a big difference anyway, so
do it only if you feel motivated. There are a lot of other things that could
be changed this way, I'd only change it while reworking other aspects in order
to avoid accidentally breaking things.

	Arnd
