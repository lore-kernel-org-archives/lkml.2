Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab1L2Gi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 01:38:56 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41658 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1L2Giy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 01:38:54 -0500
Message-ID: <4EFC0AE4.6020608@googlemail.com>
Date: Thu, 29 Dec 2011 07:38:28 +0100
From: Dirk Behme <dirk.behme@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: =?windows-1252?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>,
        netdev@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c
References: <cover.1323163127.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323163127.git.LW@KARO-electronics.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.2011 11:27, Lothar Waßmann wrote:
> The following set of patches provides some cleanup and bugfixes for
> drivers/net/ethernet/freescale/fec.c and makes the driver buildable as
> a module.
>
> Lothar WaÃŸmann (8):
>    misc cleanups
>    set con_id in clk_get() call to NULL
>    prevent dobule restart of interface on FDX/HDX change
>    don't request invalid IRQ
>    don't munge MAC address from platform data
>    preserve MII/RMII setting in fec_stop()
>    fix the .remove code
>    make FEC driver buildable as module
>
>   drivers/net/ethernet/freescale/Kconfig |    2 +-
>   drivers/net/ethernet/freescale/fec.c   |   63 ++++++++++++++++++++++----------
>   2 files changed, 44 insertions(+), 21 deletions(-)

What's the status of this patch series?

If I remember correctly, most of them got an Ack or Tested-by from 
Shawn? But one or two need an update (not sure, though)? And the 
subject should be updated?

Best regards

Dirk
