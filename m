Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2G3LbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 07:31:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32896 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2G3LbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 07:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DCEgjw1cyCV5nP-aoksboF2HFQ_emzSUXRCgGAGNuqUg@mail.gmail.com>
References: <1341340409-9347-1-git-send-email-fabio.estevam@freescale.com>
	<1343359050.1726.9033.camel@vkoul-udesk3>
	<CAOMZO5DCEgjw1cyCV5nP-aoksboF2HFQ_emzSUXRCgGAGNuqUg@mail.gmail.com>
Date: Mon, 30 Jul 2012 13:31:13 +0200
Message-ID: <CACKLOr1dLkVwy4YPMfCGL-GzLZT8BfdFmujeqUPO=xwJ73Xt1A@mail.gmail.com>
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

Hi,

On 27 July 2012 13:37, Fabio Estevam <festevam@gmail.com> wrote:
> On Fri, Jul 27, 2012 at 12:17 AM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
>
>>> Reported-by: Javier Martin <javier.martin@vista-silicon.com>
>>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>> Applied thanks (to fixes-for 3.7)
>
> You mentioned that you would also copy stable. Would it be applied
> into stable soon too?

I agree with Fabio, this patch should also be applied to stable.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
