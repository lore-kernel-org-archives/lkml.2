Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab1E0Bmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:42:42 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:44488 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab1E0Bml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:42:41 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-131.messagelabs.com!1306460560!8348815!2
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.69]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 May 2011 20:42:38 -0500
Subject: RE: [PATCH 4/5] ep93xx: remove the old M2P DMA code
Thread-Topic: [PATCH 4/5] ep93xx: remove the old M2P DMA code
Thread-Index: AcwYoq66Q1wLW/jzRkWsAzXPslrTQADbEgyA
Message-ID: <0D753D10438DA54287A00B027084269764D331A4B4@AUSP01VMBX24.collaborationhost.net>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <f4ecbf118a8478e4df2da7b8a5e9b4330892679b.1306082097.git.mika.westerberg@iki.fi>
In-Reply-To: <f4ecbf118a8478e4df2da7b8a5e9b4330892679b.1306082097.git.mika.westerberg@iki.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 22, 2011 10:03 AM, Mika Westerberg wrote:
>
> Since we have converted all existing users of the old DMA API to use the DMA
> engine API the old code can be dropped.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> ---
>  arch/arm/mach-ep93xx/Makefile           |    2 +-
>  arch/arm/mach-ep93xx/dma-m2p.c          |  411 -------------------------------
>  arch/arm/mach-ep93xx/include/mach/dma.h |  143 -----------
>  3 files changed, 1 insertions(+), 555 deletions(-)
>  delete mode 100644 arch/arm/mach-ep93xx/dma-m2p.c

Other than my comment in patch 1/5 about the old driver being builtin...

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
