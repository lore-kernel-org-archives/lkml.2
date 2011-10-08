Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1JHKIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 06:08:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab1JHKID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 06:08:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Jason Chagas <jason.chagas@marvell.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH 20/26] ARM: pxa: select FB_PXA on saar and tevorevb
Date: Sat, 08 Oct 2011 12:07:43 +0200
Message-ID: <2978851.kb50F9VMMq@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <CAMPhdO8ke1M2aFAqzfmFB-MWj6m5JsCYC_zYBC=iSX1L6kWwTw@mail.gmail.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-21-git-send-email-arnd@arndb.de> <CAMPhdO8ke1M2aFAqzfmFB-MWj6m5JsCYC_zYBC=iSX1L6kWwTw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LGDaFuUMxbRd7yxBfOcPWGKGMnqkVbE9be5ttLNWhcH
 4af7RU5V6Exqi6VMMeeAzDdO1s7Z56rNufDpSlGGJalmzIIJE9
 VKkcCjyfLhcBaQi7k94kqzhh9srCVa/azEjUwKfLx9xHiYFDK1
 3+4Fo1btCxFEintFqBxwFCDPvmEEDwRemzIeAYxGfs/uzC84/g
 B490fPR29JQe2Unu/wtx1hmtA3VdAjdf8AfLWiKwbqO4vpdJ3K
 8RAjoCXzl4r7GTnDc6niOus5zByzVQ1tCyvoSAAVZrhqezUm6w
 qF+RK2gyocNuWB0+wJnltSQxpP9Rn06KETcTwZvwSJP7If3lfW
 zhLka5EZMQknVcxyOzZM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 October 2011 17:50:31 Eric Miao wrote:
> 
> The option really matters is FB_PXA_SMARTPANEL, which adds support
> for the display driver to control an external "smart" LCD panel. And how
> about the patch below to fix this - as normal, make empty functions
> when not enabled?
> 

Yes, your patch looks better than mine.

Thanks,

	Arnd
