Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab1L1Idp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 03:33:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35373 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1L1IdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 03:33:23 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-39-4efad4516615
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Russell King'" <rmk@arm.linux.org.uk>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <20111228103326.b4f211f3c46127b8acf2dda6@canb.auug.org.au>
In-reply-to: <20111228103326.b4f211f3c46127b8acf2dda6@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the s5p tree with the arm tree
Date: Wed, 28 Dec 2011 17:33:19 +0900
Message-id: <01fd01ccc53b$5a2c5960$0e850c20$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczE8AFOCeRcqbhSSHS1ok3Zad8zAAAR1EJQ
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Kukjin,
> 
> Today's linux-next merge of the s5p tree got a conflict in
> arch/arm/mach-s5p64x0/init.c between commit 95af214becab ("ARM: 7246/1:
> S5P64X0: introduce arch/arm/mach-s5p64x0/common.[ch]") from the arm tree
> and commit afba7f91e640 ("ARM: SAMSUNG: remove struct
> 's3c24xx_uart_clksrc' and all uses of it") from the s5p tree.
> 
> I just removed the file, but the latter patch will probably need applying
> in some form to arch/arm/mach-s5p64x0/common.c.

OK, let me fix it.
Thanks for your time :)

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

