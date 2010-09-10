Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0IJXDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:03:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36550 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab0IJXDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:03:21 -0400
Date: Sat, 11 Sep 2010 08:03:33 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the s5p tree with the arm-current tree
In-reply-to: <20100910111023.671fdba7.sfr@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Russell King'" <rmk@arm.linux.org.uk>
Message-id: <002401cb513c$66c31660$34494320$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActQhPjI7s/tg3lNQtqLTbniTOcOSgAtzOPA
References: <20100910111023.671fdba7.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Kukjin,
> 
Hi :-)

> Today's linux-next merge of the s5p tree got a conflict in
> arch/arm/Kconfig between commit 9e84ed63dc71e13b62cea5ec6b0049260cca0b7a
> ("ARM: Partially revert "Auto calculate ZRELADDR and provide option for
> exceptions"") from the arm-current tree and commit
> 03c1ebb0c4e84c4de78f522a73fe1e813b9a1fc1 ("ARM: S5P64X0: Update Kconfig
> and Makefile") from the s5p tree.
> 
Oh, ok...thanks for your information.

> I used the arm-current version, but there may be some fix required for
> the s5p tree.
> 
Sure, I fixed my tree for it.

Have a nice weekend ;-)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

