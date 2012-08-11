Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab2HKMet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 08:34:49 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59577 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2HKMes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 08:34:48 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.241.31]
In-Reply-To: <CAK=WgbYxr66xUA0SsGO5b5PowRpH+mHeOSOuW+6V_S90tu=Ntg@mail.gmail.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
 <1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
 <CAJK669adq29ipOCTOyXNoqW=gF4pOJZZgZ_0tnjm75JY22Gvag@mail.gmail.com>
 <CAK=WgbbK+p3BGcohzgoY9Y57xD1kYHyGDu-FXFXaLFoA9xz7ow@mail.gmail.com>
 <CAJK669bpog-nNCZ5F5dGWqrS8p5ibob_5eq51r8+6NNimYgpGQ@mail.gmail.com> <CAK=WgbYxr66xUA0SsGO5b5PowRpH+mHeOSOuW+6V_S90tu=Ntg@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 11 Aug 2012 15:34:27 +0300
Message-ID: <CAK=WgbYF1RWoH-QxOAuO89h3P1BE84Oqs2fsUXF5eLDPPuLsAA@mail.gmail.com>
Subject: Re: [RFC 1/4] remoteproc: Bugfix assign device address to carveout (noiommu)
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Cc: linux-kernel@vger.kernel.org, Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Bhavin Shah <bshah@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 6:30 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> This will solve all sort of open issues we have (or going to have soon):
>
> 1. dynamically-allocated address of the vrings can be communicated
> 2. vdev statuses can be communicated
> 3. virtio config space will finally become bi-directional as it should
> 4. dynamically probed rproc-to-rproc IPC could then take place

and 5. let the remote processor know about the notifyids that we've
dynamically allocated.
