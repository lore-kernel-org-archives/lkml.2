Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2ASGnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:43:31 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57118 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab2ASGna convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:43:30 -0500
MIME-Version: 1.0
In-Reply-To: <1326845297-6233-1-git-send-email-rmorell@nvidia.com>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
	<1326845297-6233-1-git-send-email-rmorell@nvidia.com>
Date: Thu, 19 Jan 2012 08:43:30 +0200
X-Google-Sender-Auth: JON04HTxg6TopSUL1NIa8lqxDJI
Message-ID: <CAOJsxLETu8=a9TowOnprJg2gZkea6j3rf_63W-BZXj71xM=UjQ@mail.gmail.com>
Subject: Re: Expanding the use of DMA buffers in 3.3
From: Pekka Enberg <penberg@kernel.org>
To: Robert Morell <rmorell@nvidia.com>
Cc: linux-kernel@vger.kernel.org, sumit.semwal@linaro.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 2:08 AM, Robert Morell <rmorell@nvidia.com> wrote:
> The DMA buffer infrastructure (dma-buf) currently exposes its interface
> with EXPORT_SYMBOL_GPL.  The documentation for EXPORT_SYMBOL_GPL says:
>    "It implies that the function is considered an internal
>    implementation issue, and not really an interface."
> This interface is clearly not just an "implementation issue" but an
> interface to be used across drivers/subsystems, so I think it makes
> sense for it to use EXPORT_SYMBOL instead.
>
> Work on dma-buf was originally started with the goal of unifying several
> competing "memory management" systems developed with different ARM SoCs
> in mind.  It would be unfortunate if restricting its use to only
> GPL-licensed modules caused dma-buf adoption to be limited.
>
> For convenience, I'll send the trivial patch to implement this change.
> I'd like to see this in the first release with dma-buf in 3.3.

How about you open up your driver code instead? You'd get access to
all EXPORT_SYMBOL_GPL symbols instantly!

                        Pekka
