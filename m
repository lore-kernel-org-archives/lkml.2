Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab2IRKb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:31:58 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:41042 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941Ab2IRKbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:31:48 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH 09/24] ARM: ixp4xx: use __iomem pointers for MMIO
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
	<1347658492-11608-10-git-send-email-arnd@arndb.de>
Date: Tue, 18 Sep 2012 12:31:45 +0200
In-Reply-To: <1347658492-11608-10-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Fri, 14 Sep 2012 23:34:37 +0200")
Message-ID: <m3ipbbmxke.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
>
> At the moment, this patch conflicts with other patches in linux-next,
> need to sort this out.

Very nice, I will take care of these 3 patches.
-- 
Krzysztof Halasa
