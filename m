Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2BBB7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:59:51 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46355 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509Ab2BBB7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:59:49 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <CAN1soZyatf2u4fVk-=U_Sz4wcVwP7qFaiZK4CR3rosbXeQObvA@mail.gmail.com>
References: <1324974344.2351.5.camel@phoenix> <CAMPhdO_QL3ahf4+F70Bg7FHKq5mrbbofN_BTz8dpcBLea9BNAw@mail.gmail.com>
 <25B60CDC2F704E4E9D88FFD52780CB4C05EC64DBD3@SC-VEXCH1.marvell.com>
 <CAMPhdO8=L1KGmn_OihoMmMWNDahZ5+3u7M+BNuT3FcSfExHm1w@mail.gmail.com> <CAN1soZyatf2u4fVk-=U_Sz4wcVwP7qFaiZK4CR3rosbXeQObvA@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 2 Feb 2012 09:59:28 +0800
Message-ID: <CAF+7xW=VmaOATC1-J3u=s7pjuK-xefo+5zzZ3GpqVot7JJOfDA@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: pxa: fix error handling in pxa2xx_drv_pcmcia_probe
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Haojian Zhuang <hzhuang1@marvell.com>,
        "linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> If it fails, it will jump to err1 anyway. The check there is redundant.
>>
> Applied

Hi Haojian,
This patch is not (yet) upstream.
Could you help to check it again.

Thanks,
Axel
