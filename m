Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2GaLqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 07:46:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34546 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab2GaLqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 07:46:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5ByAofqsWRPWRE1O1ZaNhbSi8WmrAS+sLeATUxgBwv1Dg@mail.gmail.com>
References: <1341340409-9347-1-git-send-email-fabio.estevam@freescale.com>
	<1343359050.1726.9033.camel@vkoul-udesk3>
	<CAOMZO5DCEgjw1cyCV5nP-aoksboF2HFQ_emzSUXRCgGAGNuqUg@mail.gmail.com>
	<CACKLOr1dLkVwy4YPMfCGL-GzLZT8BfdFmujeqUPO=xwJ73Xt1A@mail.gmail.com>
	<CACKLOr1BHZR+d8UwSCtnEhO=CnrmGBsD8Tt_KtrBCmWEvE4Z=Q@mail.gmail.com>
	<1343717200.1726.14407.camel@vkoul-udesk3>
	<CAOMZO5ByAofqsWRPWRE1O1ZaNhbSi8WmrAS+sLeATUxgBwv1Dg@mail.gmail.com>
Date: Tue, 31 Jul 2012 13:46:50 +0200
Message-ID: <CACKLOr0+gErZaX_6-LAxrT-8HsEGpa_3SWP8D_nPQfLgs6Kskw@mail.gmail.com>
Subject: Re: [PATCH] dma: imx-dma: Fix kernel crash due to missing clock conversion
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2012 13:38, Fabio Estevam <festevam@gmail.com> wrote:
> On Tue, Jul 31, 2012 at 3:46 AM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
>
>> This patch will appear in 3.7-rc2 when I send the fixes to Linus post
>> rc1,  I guess early next week.
>
> I guess you mean 3.6-rc2, right?
>
>> Stable guys will pick this and apply to 3.6.X version.
>
> I guess you mean 3.5.x, right?

Ditto.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
