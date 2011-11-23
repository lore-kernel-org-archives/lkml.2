Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1KWQzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:55:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10477 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab1KWQzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:55:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 23 Nov 2011 08:55:40 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 23 Nov 2011 08:55:39 -0800
Subject: RE: [PATCH] ARM: tegra: remove declaration of
 tegra_assert_system_reset in board.h
Thread-Topic: [PATCH] ARM: tegra: remove declaration of
 tegra_assert_system_reset in board.h
Thread-Index: Acypz7xKNHs6HJY9Q46rQgjM+iyeswAMNZmw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C6C7@HQMAIL01.nvidia.com>
References: <1322046284.27165.1.camel@phoenix>
In-Reply-To: <1322046284.27165.1.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pANGtpKj009298

Axel Lin wrote at Wednesday, November 23, 2011 4:05 AM:
> commit b2f745 "ARM: restart: tegra: use new restart hook"
> changed tegra_assert_system_reset to be static but forgot to
> remove the declaration in arch/arm/mach-tegra/board.h.

Please see:

http://www.spinics.net/lists/arm-kernel/msg148932.html

Thanks.

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
