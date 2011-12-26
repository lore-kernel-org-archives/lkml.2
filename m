Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1LZP31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 10:29:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49246 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab1LZP3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 10:29:25 -0500
Date: Mon, 26 Dec 2011 16:29:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43: support new RX header, noticed to be used in 598.314+
 fw
Message-ID: <alpine.DEB.2.00.1112261608140.12108@axis700.grange>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:Bv6yiztzH+28u9i7DPoB0F/ntf5Jq9VA4p1xKqRh2qI
 ER+OJ/bZvl8E/YZV5CezOWRwZwBh3KZThgjDIVMpbuaHHO5FDr
 ffXIIfmUhQexvsFRaTsg+OjerV5aWpfe1SooRfmBZDdbxH7nod
 ZYwrVWROtKM540DpvLrJ4qlF8GWSWdyzlTwe7ZAdLG2mY/9FXF
 eyLpw+xonccxPX7iPgnO4gPBXkRYZxtIGfEdEj0QzxWY+0UQGs
 OpPPW3YU+BkzmLIKDZr/3sVzDiJqw8y9IrDa2MJdh7RJ1y/1Rd
 pzebBMhhTnECPEPYOu4aEVJ74nekZJ8SQt6+y49EPvsvGcwtjm
 zluRww06Qj6DI21DQhDQs8fAzNQvy+zB8dBw7SPvBgEIGvFv7+
 jgzxzRmG7u7ng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for "simulating" a reply - I'm not subscribed to linux-wireless, so,
cannot (easily) reply.
   
The commit in subject line

commit 17030f48e31adde5b043741c91ba143f5f7db0fd
From: Rafa³ Mi³ecki <zajec5@gmail.com>
Date: Thu, 11 Aug 2011 17:16:27 +0200
Subject: [PATCH] b43: support new RX header, noticed to be used in 598.314+ fw

breaks my b43 SDIO card in 3.2-ish kernels. Given the approaching 
3.2-final release, would be nice to have it fixed before that. The card 
I've got is marked with some "SD-Link11g" from some "C-guys, Inc." from 
Taiwan:-) Using firmware version 410.31754. Do I really _have_ to update 
or is the driver supposed to handle "all" firmware versions, or at least 
not drop ones, it used to support before?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
