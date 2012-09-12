Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2ILJG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:06:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38688 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2ILJGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:06:24 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.103.139]
In-Reply-To: <1346286292-21773-1-git-send-email-fernando.lugo@ti.com>
References: <1346286292-21773-1-git-send-email-fernando.lugo@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 12 Sep 2012 12:06:03 +0300
Message-ID: <CAK=WgbYg_j_Ym2RBX_pX0RaSEh9KiPHUmieqyVwNV+JVEcvEGQ@mail.gmail.com>
Subject: Re: [PATCH] rpmsg: use right device paramter when calling
 dma_free_coherent function
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fernando,

On Thu, Aug 30, 2012 at 3:24 AM, Fernando Guzman Lugo
<fernando.lugo@ti.com> wrote:
> dma_alloc/free_coherent APIs requires the platform specific remoteproc
> device as the device parameter. We are passing vdev->dev.parent to the
> dma_free_coherent function which is the generic rproc device and it is
> wrong, it has to be vdev->dev.parent->parent instead, same as when we
> call dma_alloc_coherent function.
>
> Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>

Thanks, applied to rpmsg-fixes.

Ohad.
