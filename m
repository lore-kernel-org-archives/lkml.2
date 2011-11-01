Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1KASzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:55:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53479 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525Ab1KASzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:55:23 -0400
Date: Tue, 1 Nov 2011 18:55:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v8 3/3 RESEND] ASoC: da7210: Add support for
 line input and mic
Message-ID: <20111101185520.GK10029@opensource.wolfsonmicro.com>
References: <1320153149.4064.16.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320153149.4064.16.camel@matrix>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 06:42:29PM +0530, Ashish Chavan wrote:
> DA7210 has three line inputs (AUX1 Left, AUX1 Right and AUX2) and
> a stereo MIC. This patch adds gain controls for MIC, AUX1, AUX2 as
> well as INPGA.
> 
> Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>

Applied, thanks.  When resending patches you should always include any
acks that were given on previous postings.
