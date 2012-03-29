Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab2C2Cmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:42:44 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:30042
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758539Ab2C2Cmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:42:38 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzzz2dh2a8h668h839h941hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F73CCC6.6000001@freescale.com>
Date: Thu, 29 Mar 2012 10:45:26 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de> <1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram:
>  include/linux/stmp_device.h |   20 +++++++++++
IMHO, this header should be placed at include/linux/fsl/.
But the patch "mxs-dma : move the mxs dma.h to a more common place" is
still in the l2-mtd tree, not pushed
to upstream. :(

BR
Huang Shijie


