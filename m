Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1HaNjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:39:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51583 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1HaNjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:39:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 08/35] Hexagon: Add delay functions
Date: Wed, 31 Aug 2011 15:39:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190800.478027955@codeaurora.org>
In-Reply-To: <20110830190800.478027955@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311539.43528.arnd@arndb.de>
X-Provags-ID: V02:K0:ty9BLQ9BIlcToqHE1Lf6Hnwh72OIvsabzA6WeAH3AOd
 Qd/E6CKYS/C57a7AQG06TA0KAz313kGcnSJmHLpKfKuP13qYJk
 39N40sBTn1NPRm+IgICukq5fTT0iOEbfRDYG8HlIpqdPNWxcoh
 VpVMSt4n6DSaaWK44hqyV463p5ciiXHZanKYsWG74SpgWYUpQ9
 ar88DvTrZsFDTcLJr4L7iW7qoxqqtWgUv+goL0/npcF9UE732i
 9u8IuqMOwrso5HYTdE4RrCiPDiq2HR7a4UH9o9602grYcza7er
 dwEajwq3BeRgo8OIxl+XaIwx3LQMpfRq/BUlirMLM+zVREslWe
 m5mHzfyzaok6mjxaXgjg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> Added read_current_timer elsewhere, so __delay isn't really used.
> 
> udelay is based off of __vmgettime() which returns processor ticks.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

Why do you still provide __delay then?

If you disable CONFIG_GENERIC_CALIBRATE_DELAY, it should just never
be called at all so you can remove it.

	Arnd
