Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3AHEtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 23:49:15 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:39835 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3AHEtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 23:49:13 -0500
MIME-Version: 1.0
In-Reply-To: <20130108093557.8a29d4a04b95702fc59790ff@canb.auug.org.au>
References: <20130108093557.8a29d4a04b95702fc59790ff@canb.auug.org.au>
Date: Tue, 8 Jan 2013 10:19:12 +0530
X-Google-Sender-Auth: BL1TTVXbr0JI13T-RIBTJOu6E2M
Message-ID: <CAOh2x=kJjv01bFLKqnAADfnW1t64YjPwM05Xs=5XXR8yB5my1w@mail.gmail.com>
Subject: Re: linux-next: comment in commit in the slave-dma tree (dmaengine:
 dw_dmac: Enhance device tree support)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 4:05 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> In commit 548860697046 ("dmaengine: dw_dmac: Enhance device tree
> support") (which was changed since yesterday :-(), an instance of
> __devinit has been added.  We are in the process of making CONFIG_HOTPLUG
> always true, and since commit 78d86c213f28 ("init.h: Remove __dev*
> sections from the kernel") (included in v3.7), __devinit does nothing.
> Please do not add any more.

When this patch got added, __devinit discussion just started. Because Vinod
missed the merge window, we still have this patch in linux-next.

@Vinod: I hope you can edit this patch yourself?

--
viresh
