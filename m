Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1FFHYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:24:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35896 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163Ab1FFHYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:24:17 -0400
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 6 Jun 2011 12:53:57 +0530
Subject: RE: [PATCH] ARM: omap4: gpio: fix setting IRQWAKEN bits
Thread-Topic: [PATCH] ARM: omap4: gpio: fix setting IRQWAKEN bits
Thread-Index: AcwkF7r0IR9X5DaZRC+BnOZxZeygKQAAhD7Q
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB037B7B69A6@dbde02.ent.ti.com>
References: <1307214239-16316-1-git-send-email-ccross@android.com>
 <4DEC7B6D.6060901@ti.com>
In-Reply-To: <4DEC7B6D.6060901@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Shilimkar, Santosh
> Sent: Monday, June 06, 2011 12:32 PM
> To: Colin Cross
> Cc: linux-omap@vger.kernel.org; Tony Lindgren; Russell King; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] ARM: omap4: gpio: fix setting IRQWAKEN bits
> 
> On 6/5/2011 12:33 AM, Colin Cross wrote:
> > Setting the IRQWAKEN bit was overwriting previous IRQWAKEN bits,
> > causing only the last bit set to take effect, resulting in lost
> > wakeups when the GPIO controller is in idle.
> >
> > Replace direct writes to IRQWAKEN with writes to SETWKUENA and
> > CLEARWKUEN.
> >
> > Signed-off-by: Colin Cross<ccross@android.com>
> 
> Looks good. This needs to be fixed on top of the clean-up
> branch where GPIO movemnt to driver/gpio/* happening.
> 
> For this change,
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
This is also available as part of following cleanup series we are doing.
However, since this is a defect we can prioritize it over the cleanup.
--
Tarun
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
