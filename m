Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab1E0Bni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:43:38 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:58241 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab1E0Bnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:43:37 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1306460616!25802743!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.69]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 26 May 2011 20:43:34 -0500
Subject: RE: [PATCH 3/5] ASoC: ep93xx: convert to use the DMA engine API
Thread-Topic: [PATCH 3/5] ASoC: ep93xx: convert to use the DMA engine API
Thread-Index: AcwYoplThhyNDxQUQZmdSn4ql6/XAADbM5Lg
Message-ID: <0D753D10438DA54287A00B027084269764D331A4B5@AUSP01VMBX24.collaborationhost.net>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <9f8dd1eb40a6cb44d8207c84f244345a98bb9c0f.1306082097.git.mika.westerberg@iki.fi>
In-Reply-To: <9f8dd1eb40a6cb44d8207c84f244345a98bb9c0f.1306082097.git.mika.westerberg@iki.fi>
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
> Now that we have the EP93xx DMA engine driver in place, we convert the ASoC
> drivers (I2S, AC97 and PCM) to take advantage of this new API. There are no
> functional changes.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
