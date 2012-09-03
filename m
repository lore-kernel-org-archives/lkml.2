Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab2ICQIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 12:08:16 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:24002
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756315Ab2ICQIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 12:08:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I4015Izz1202hzz8275bhz2dh2a8h668h839hd25he5bhf0ah107ah1155h)
Message-ID: <5044D7E6.5070901@freescale.com>
Date: Mon, 3 Sep 2012 13:16:38 -0300
From: Fabio Estevam <fabio.estevam@freescale.com>
Organization: Freescale Semiconductor
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <festevam@gmail.com>, <broonie@opensource.wolfsonmicro.com>,
        <gcembed@gmail.com>, <s.hauer@pengutronix.de>
Subject: Re: [ASoC] Fix: Revert 'ASoC: imx-ssi: Remove mono support'.
References: <1346660831-9662-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1346660831-9662-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

Javier Martin wrote:
> The following commit should be reverted: 0865a75d4166bddc533fd50831829ceefb94f9b0
> 
> The bug this patch is meant to solve doesn't occur in Visstrim_M10 boards.
> Furthermore, after applying this patch sound in Visstrim_M10 is played
> at slower rates.

Acked-by: Fabio Estevam <fabio.estevam@freescale.com>

Sorry for breaking this.

Ok, I managed to fix the original issue inside the mc13783 codec driver and just sent a patch.

Thanks,

Fabio Estevam

