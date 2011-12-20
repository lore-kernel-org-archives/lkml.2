Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1LTO3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:29:49 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:38902 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694Ab1LTO3n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:29:43 -0500
MIME-Version: 1.0
In-Reply-To: <20111220020549.GQ6559@morell.nvidia.com>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<4EE33EC2.6050508@redhat.com>
	<20111212224408.GD4355@morell.nvidia.com>
	<201112131510.02785.arnd@arndb.de>
	<20111220020549.GQ6559@morell.nvidia.com>
Date: Tue, 20 Dec 2011 16:29:42 +0200
Message-ID: <CAJL_dMvYYWyx8xD4B75wXdKg+bD959i1LTWXD8b+yrW6HuxnTg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer
 sharing mechanism
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Robert Morell <rmorell@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sumit Semwal <sumit.semwal@ti.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "jesse.barker@linaro.org" <jesse.barker@linaro.org>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 4:05 AM, Robert Morell <rmorell@nvidia.com> wrote:
>
> One of the goals of this project is to unify the fragmented space of the
> ARM SoC memory managers so that each vendor doesn't implement their own,
> and they can all be closer to mainline.

That is a very good objective.

> I fear that restricting the use of this buffer sharing mechanism to GPL
> drivers only will prevent that goal from being achieved, if an SoC
> driver has to interact with modules that use a non-GPL license.

If nobody from nvidia have any experience with this kind of work...
Look at Intel. Why are you afraid of ?

> As a hypothetical example, consider laptops that have multiple GPUs.
> Today, these ship with onboard graphics (integrated to the CPU or
> chipset) along with a discrete GPU, where in many cases only the onboard
> graphics can actually display to the screen.  In order for anything
> rendered by the discrete GPU to be displayed, it has to be copied to
> memory available for the smaller onboard graphics to texture from or
> display directly.  Obviously, that's best done by sharing dma buffers
> rather than bouncing them through the GPU.  It's not much of a stretch
> to imagine that we'll see such systems with a Tegra CPU/GPU plus a
> discrete GPU in the future; in that case, we'd want to be able to share
> memory between the discrete GPU and the Tegra system.  In that scenario,
> if this interface is GPL-only, we'd be unable to adopt the dma_buffer
> sharing mechanism for Tegra.
>
> (This isn't too pie-in-the-sky, either; people are already combining
> Tegra with discrete GPUs:
> http://blogs.nvidia.com/2011/11/world%e2%80%99s-first-arm-based-supercomputer-to-launch-in-barcelona/
> )
>
> Thanks,
> Robert

There are other problems ? Some secret agreements with Microsoft ?

I hope to see something open sourced. You can do it nVidia.
