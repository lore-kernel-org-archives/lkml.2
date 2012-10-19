Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348Ab2JSNpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:45:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44718 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964837Ab2JSNpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:45:38 -0400
MIME-Version: 1.0
Date: Fri, 19 Oct 2012 15:45:36 +0200
Message-ID: <CAJK669Zg3+TR5i6jYDEcUzAyf79+Y41i3rs8dB=e_irqMWHEUQ@mail.gmail.com>
Subject: remoteproc open issues (was [RFC 1/4] remoteproc: Bugfix assign
 device address to carveout (noiommu)
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Bhavin Shah <bshah@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 10, 2012 at 5:30 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> The general direction I have in mind is to put the resource table in
> its final location while we do the first pass of fw parsing.
>
> This will solve all sort of open issues we have (or going to have soon):
>
> 1. dynamically-allocated address of the vrings can be communicated
> 2. vdev statuses can be communicated
> 3. virtio config space will finally become bi-directional as it should
> 4. dynamically probed rproc-to-rproc IPC could then take place
>
> It's the real deal :)
>
> The only problem with this approach is that the resource table isn't
> reloaded throughout cycles of power up/down, and that is insecure.
> We'll have to manually reload it somewhere after the rproc is powered
> down (or before it is powered up again).
>
> This change will break existing firmwares, but it looks required and inevitable.

Has anyone started looking into any of the open issues mentioned above?

Thanks,
Sjur
