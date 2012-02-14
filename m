Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab2BNLvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:51:44 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51732 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619Ab2BNLvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:51:42 -0500
MIME-Version: 1.0
In-Reply-To: <1328884300-18801-1-git-send-email-javier.martin@vista-silicon.com>
References: <1328884300-18801-1-git-send-email-javier.martin@vista-silicon.com>
Date: Tue, 14 Feb 2012 12:51:41 +0100
Message-ID: <CACKLOr1Gn_NR8HPhmyK6DW9W+7CGG8y7yoZm6PE3bH2zt6Ej-g@mail.gmail.com>
Subject: Re: [PATCH 0/4] dmaengine: i.MX DMA series.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 February 2012 15:31, Javier Martin
<javier.martin@vista-silicon.com> wrote:
> Patches 1-3 have already been sent to the list (not merged yet)
> but they are submitted so that everyone can get the whole picture
> of what we're trying to do here.
>
> A new patch(4) has been added which adds support for multiple
> descriptors.
>
> [PATCH 1/4] dmaengine: Add support for MEMCPY for imx-dma.
> [PATCH 2/4] i.MX DMA: Add support for 2D transfers.
> [PATCH 3/4] dmaengine: i.MX: Add support for interleaved transfers.
> [PATCH 4/4] dmaengine: Add support for multiple descriptors for imx-dma.

Hi,
what do you think of this series?

Vinod: your concern about patch 1 is solved in patch 4
Sascha: I know you are not comfortable with patch 2 since it adds code
to a file which is meant to be removed. However, is there a chance you
accept it without me having to rewrite the whole series?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
