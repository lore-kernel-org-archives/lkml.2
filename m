Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2CHCGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:06:41 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:38677
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347Ab2CHCGj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:06:39 -0500
X-SpamScore: 3
X-BigFish: VS3(zzc89bhzz1202h1082kzzz2dh2a8h668h839h941h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F5814C6.1080801@freescale.com>
Date: Thu, 8 Mar 2012 10:09:10 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Shawn Guo <shawn.guo@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] drivers: base: add support for stmp-style devices
References: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de> <1331159314-12022-2-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1331159314-12022-2-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年03月08日 06:28, Wolfram Sang 写道:
> All this is strictly speaking not mach-specific (but IP core specific) and,
> thus, doesn't need to be in mach-mxs/include. At least mx6 also uses IP cores
> following this stmp-style. So:
>
mx50 also uses the same IP core.

BR
Huang Shijie

