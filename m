Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab2CMIsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:48:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62842 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab2CMIsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:48:41 -0400
MIME-Version: 1.0
In-Reply-To: <1331241078-29977-1-git-send-email-alexandre.bounine@idt.com>
References: <1331241078-29977-1-git-send-email-alexandre.bounine@idt.com>
Date: Tue, 13 Mar 2012 09:48:37 +0100
Message-ID: <CACRpkda35TE6qttTyFeD0et_whzUQEroz-5KSPmNbjkXA8iRAA@mail.gmail.com>
Subject: Re: [PATCH 1/2 V2] dmaengine/dma_slave: introduce inline wrappers
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        linus.walleij@stericsson.com, leoli@freescale.com, zw@zh-kernel.org,
        STEricsson_nomadik_linux@list.st.com, ben-linux@fluff.org,
        kgene.kim@samsung.com, mchehab@infradead.org,
        ludovic.desroches@atmel.com, cjb@laptop.org, g.liakhovetski@gmx.de,
        ian@mnementh.co.uk, dwmw2@infradead.org, grant.likely@secretlab.ca,
        alan@linux.intel.com, balbi@ti.com, FlorianSchandinat@gmx.de,
        perex@perex.cz, tiwai@suse.de, viresh.kumar@st.com,
        baohua.song@csr.com, srinidhi.kasagar@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 10:11 PM, Alexandre Bounine
<alexandre.bounine@idt.com> wrote:

> Add inline wrappers for device_prep_slave_sg() and device_prep_dma_cyclic()
> interfaces to hide new parameter from current users of affected interfaces.
> Convert current users to use new wrappers instead of direct calls.
> Suggested by Russell King [https://lkml.org/lkml/2012/2/3/269].
>
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>

Looks like a good idea to me:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
