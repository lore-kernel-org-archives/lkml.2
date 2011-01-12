Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab1ALFXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:23:06 -0500
Received: from mail.atheros.com ([12.19.149.2]:43986 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1ALFXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:23:04 -0500
Date: Wed, 12 Jan 2011 10:52:28 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Bernhard Walle <walle@corscience.de>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
        Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] ath9k: Fix reporting of RX STBC streams to
	userspace
Message-ID: <20110112052227.GE31650@vasanth-laptop>
References: <1294765194-30542-1-git-send-email-walle@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1294765194-30542-1-git-send-email-walle@corscience.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 10:29:54PM +0530, Bernhard Walle wrote:
> While the driver reports
> 
>         ath: TX streams 2, RX streams: 2
> 
> in the kernel log (with ATH_DBG_CONFIG set in the debug module
> parameter), "iw list" only reported
> 
> [...]
>         Capabilities: 0x12ce
>                 HT20/HT40
>                 SM Power Save disabled
>                 RX HT40 SGI
>                 TX STBC
>                 RX STBC 1-streams
> [...]
> 
> The driver seems to set the value as flag while the iw tool interprets
> it as number. This patch fixes that.

Nope. hw supports STBC for one Spatial stream only.

Vasanth
