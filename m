Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1GBTiO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 15:38:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58744 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1GBTiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 15:38:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v8 00/12] use nonblock mmc requests to minimize latency
Date: Sat, 2 Jul 2011 21:37:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Per Forlin <per.forlin@linaro.org>,
        Nickolay Nickolaev <nicknickolaev@gmail.com>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org> <201107011844.44058.arnd@arndb.de> <20110702122938.GI21898@n2100.arm.linux.org.uk>
In-Reply-To: <20110702122938.GI21898@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107022137.30138.arnd@arndb.de>
X-Provags-ID: V02:K0:EML+osaVD3eN+WlWgMI5cbSGiWYljM5i4XKAuXzGCq2
 IwefOI5qM54h2s3E7xShxW9rE5je+X0sjqnJD07FSHfnYkRbsC
 WB2ZE0WFl8hCfCVweUqR6x3QKM+yF3ztoh7c+yUa4BoFbyq8Tz
 C9Hn8HNJRUwJPVnyaDDPhdS1ftipPoEwvDwmTb19nvLiWG+0Vg
 SV4ex/cQCxdZaJasjxDwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011 14:29:38 Russell King - ARM Linux wrote:
> One other thing to be considered here is whether this idea should be
> limited to just MMC or whether it should be extended further, to
> move the DMA mapping stuff out of the hot path for other block devices
> too.
> 
> There are ARM systems with SATA which do 28MB/s - which could be
> improved by this technique.

Excellent point. We had discussed SATA items in the context of Linaro
work before, and the conclusion was always that we wouldn't need to
do any work for it in the common code. I'll make sure that we bring
it up at the meeting next month in Cambridge so we can officially
assign someone to do this.

	Arnd
