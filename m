Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2CGHwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 02:52:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65491 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2CGHwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 02:52:41 -0500
MIME-Version: 1.0
In-Reply-To: <1331102571.24656.324.camel@vkoul-udesk3>
References: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
	<1330964196-32623-2-git-send-email-javier.martin@vista-silicon.com>
	<1331102571.24656.324.camel@vkoul-udesk3>
Date: Wed, 7 Mar 2012 08:52:40 +0100
Message-ID: <CACKLOr0iBSMd8hNdmeAiMWgyyUb_b1=5n47N97hu9EP2Zu9OsQ@mail.gmail.com>
Subject: Re: [PATCH 01/14] dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c
From: javier Martin <javier.martin@vista-silicon.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        dan.j.williams@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On 7 March 2012 07:42, Vinod Koul <vinod.koul@intel.com> wrote:
> On Mon, 2012-03-05 at 17:16 +0100, Javier Martin wrote:
> Sascha,
> Are there any more users of dmac in mach-imx?

No, there are no other users of mach-imx. In fact, it was Sascha's
idea to make this merge [1].

> If not then why not move the code, rather than copy.
> If yes can we move them as well?

I do remove the code in mach-imx in PATCH 14/14. I considered it was
better doing this in the last patch to keep the old code available
during the whole development process.

[1] https://lkml.org/lkml/2012/2/9/171

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
