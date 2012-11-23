Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab2KWM1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:27:21 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:35861
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651Ab2KWM1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:27:19 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI4015Izz1de0h1202h1d1ah1d2ahzzz2dh2a8h668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
Message-ID: <50AF6E64.2060107@freescale.com>
Date: Fri, 23 Nov 2012 10:39:00 -0200
From: Fabio Estevam <fabio.estevam@freescale.com>
Organization: Freescale Semiconductor
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: javier Martin <javier.martin@vista-silicon.com>
CC: "kernel@pengutronix.de" <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>,
        "festevam@gmail.com >> Fabio Estevam" <festevam@gmail.com>
Subject: Re: [PATCH v4 1/3] ARM: imx27_visstrim_m10: Do not reserve DMA pools
 on board file
References: <1353600769-28693-1-git-send-email-fabio.estevam@freescale.com> <CACKLOr296rVjv3ECL_WyV2eS7OHEKFzBomz=i-6dJWOvJQ9pkQ@mail.gmail.com>
In-Reply-To: <CACKLOr296rVjv3ECL_WyV2eS7OHEKFzBomz=i-6dJWOvJQ9pkQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

javier Martin wrote:
> Hi Fabio,
> have you actually tested CMA with mx2_camera and coda drivers in i.MX27?

Only probe tested it. Please ket me know if you have issues.

Thanks,

Fabio Estevam

