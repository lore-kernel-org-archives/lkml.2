Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2IRTWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:22:13 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:42584 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab2IRTWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:22:08 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Imre Kaloz <kaloz@openwrt.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/24] ARM: ixp4xx: use __iomem pointers for MMIO
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
	<1347658492-11608-10-git-send-email-arnd@arndb.de>
	<m3ipbbmxke.fsf@intrepid.localdomain>
Date: Tue, 18 Sep 2012 21:22:06 +0200
In-Reply-To: <m3ipbbmxke.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Tue, 18 Sep 2012 12:31:45 +0200")
Message-ID: <m3ipbbdtlt.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

>> At the moment, this patch conflicts with other patches in linux-next,
>> need to sort this out.
>
> Very nice, I will take care of these 3 patches.

I mean, just this one IXP4xx patch :-)
-- 
Krzysztof Halasa
