Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab2GKMNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:13:17 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:49743 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117Ab2GKMNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <CADysL2ZD0yCpCodeuwDpiaiD=uYuDfv4MDXN=YWa-LfY1-8pjA@mail.gmail.com>
References: <CADysL2ZD0yCpCodeuwDpiaiD=uYuDfv4MDXN=YWa-LfY1-8pjA@mail.gmail.com>
Date: Wed, 11 Jul 2012 17:43:12 +0530
Message-ID: <CADysL2YuOuCQEDpy0TdWJHaSmiotg-utnPSnhmxCetH0XBVRPg@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] add new cache maintenance api
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Thu, Jul 5, 2012 at 10:50 AM, Gupta, Ramesh <grgupta@ti.com> wrote:
> From 393c4effbbec74ff9b969d53ce4d36fde56b71df Mon Sep 17 00:00:00 2001
> From: Ramesh Gupta G <grgupta@ti.com>
> Date: Wed, 4 Jul 2012 16:43:41 +0530
> Subject: [PATCH v4 0/2] add new cache maintenance api
>
> This patch series is the next version to
> - add a new cache maintenance api to support non-coherent iommu drivers.
> - flush both L1 and L2 caches from OMAP iommu whenever the page table
>   memory is updated.
>
> Changes since the previous patch set (v3)
> - Minor cleanup for fixing checkpatch warnings.
>
> The implementation of the new api is based on
> the approach[1] discussed.
>
> [1]http://marc.info/?l=linux-kernel&m=131316512713815&w=2


Did you get a chance to review this patch series? Please let me know
if I miss anything.

thank you and regards
Ramesh Gupta G
