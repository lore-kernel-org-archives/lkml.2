Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2DJKUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:20:03 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:54770 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294Ab2DJKUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:20:00 -0400
Message-ID: <1334053195.10398.0.camel@cumari>
Subject: Re: [PATCH v2] wl12xx: fix DMA-API-related warnings
From: Luciano Coelho <coelho@ti.com>
To: Mircea Gherzan <mgherzan@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 10 Apr 2012 13:19:55 +0300
In-Reply-To: <1332006114-30230-1-git-send-email-mgherzan@gmail.com>
References: <1332006114-30230-1-git-send-email-mgherzan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-17 at 18:41 +0100, Mircea Gherzan wrote: 
> On the PandaBoard (omap_hsmmc + wl12xx_sdio) with DMA_API_DEBUG:
> 
>  WARNING: at lib/dma-debug.c:930 check_for_stack.part.8+0x7c/0xe0()
>  omap_hsmmc omap_hsmmc.4: DMA-API: device driver maps memory fromstack
> 
> Signed-off-by: Mircea Gherzan <mgherzan@gmail.com>
> ---

Pushed, thanks for fixing this!

-- 
Cheers,
Luca.

