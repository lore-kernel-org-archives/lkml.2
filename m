Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0LaB75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 20:59:57 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64189 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab0LaB74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 20:59:56 -0500
Date: Fri, 31 Dec 2010 10:59:47 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the sound-asoc tree with the s5p tree
In-reply-to: <20101231115609.53355fc7.sfr@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassi.brar@samsung.com>
Message-id: <011301cba88e$69bff000$3d3fd000$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcuohYZzeRiJtRopQ/yeqe3Oot/KWwAB+SMw
References: <20101231115609.53355fc7.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi all,
> 
Hi :-)

> Today's linux-next merge of the sound-asoc tree got a conflict in
> arch/arm/plat-samsung/include/plat/devs.h between commit
> 1b6e8eda6f0e7cd4f28e522a5e77e76f6985af9d ("Merge branch 'next-s5pv310'
> into for-next") from the s5p tree and commit
> 83e37b8e400ca51cc97946815b3055daacd92fa8 ("ARM: Samsung: Define common
> audio-dma device") from the sound-asoc tree.
> 
Oops, sorry for bothering again :-(
I will re-merge it in my for-next for avoiding conflict.

> I fixed it up (see below) and can carry the fix as necessary.

Thanks for your information and Happy New year!

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

