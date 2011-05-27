Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab1E0Bol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:44:41 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:41194 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab1E0Bok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:44:40 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1306460679!1173930!2
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.72]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 May 2011 20:44:37 -0500
Subject: RE: [PATCH 2/5] ep93xx: add dmaengine platform code
Thread-Topic: [PATCH 2/5] ep93xx: add dmaengine platform code
Thread-Index: AcwYonnn5oxH+SVBRM2fydwqwBT6ugDbRENg
Message-ID: <0D753D10438DA54287A00B027084269764D331A4B6@AUSP01VMBX24.collaborationhost.net>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <e903b474448f984f024682b1f565e8ef23c3b842.1306082097.git.mika.westerberg@iki.fi>
In-Reply-To: <e903b474448f984f024682b1f565e8ef23c3b842.1306082097.git.mika.westerberg@iki.fi>
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
> Add platform support code for the new EP93xx dmaengine driver.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> ---
>  arch/arm/mach-ep93xx/Makefile |    2 +-
>  arch/arm/mach-ep93xx/dma.c    |  108 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-ep93xx/dma.c

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
