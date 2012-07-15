Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2GOKLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 06:11:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35390 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2GOKK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 06:10:27 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.44.123]
In-Reply-To: <CAK=WgbZu1hYOd27r259b2v48VFYeOZ4UE5sD2awZDxgBgjAsXw@mail.gmail.com>
References: <1338017791-9442-1-git-send-email-ohad@wizery.com>
 <1338017791-9442-2-git-send-email-ohad@wizery.com> <4FC5DD74.4030202@codeaurora.org>
 <CAK=WgbbwaMAnTGcivC9ZR8K-MtTqHAV3+BgUmk8WjCaayifJxw@mail.gmail.com>
 <4FCD272E.1020300@codeaurora.org> <CAK=WgbZu1hYOd27r259b2v48VFYeOZ4UE5sD2awZDxgBgjAsXw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 15 Jul 2012 13:10:05 +0300
Message-ID: <CAK=WgbY3BbAN73k8yzNBXob2gkY2_sbhh9a_0yjvy=3Hy5wEbw@mail.gmail.com>
Subject: Re: [PATCH 2/2] remoteproc: remove the now-redundant kref
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 11:52 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> From 0fbf3004c1a52ae4c0554366409a2bfe401801ef Mon Sep 17 00:00:00 2001
> From: Ohad Ben-Cohen <ohad@wizery.com>
> Date: Mon, 2 Jul 2012 11:41:16 +0300
> Subject: [PATCH] remoteproc: simplify unregister/free interfaces
>
> Simplify the unregister/free interfaces, and make them easier
> to understand and use, by moving to a symmetric and consistent
> alloc() -> register() -> unregister() -> free() flow.
>
> To create and register an rproc instance, one needed to invoke
> rproc_alloc() followed by rproc_register().
>
> To unregister and free an rproc instance, one now needs to invoke
> rproc_unregister() followed by rproc_free().
>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  Documentation/remoteproc.txt         | 21 ++++++++-------------
>  drivers/remoteproc/omap_remoteproc.c |  5 ++++-
>  drivers/remoteproc/remoteproc_core.c | 25 ++++++++-----------------
>  3 files changed, 20 insertions(+), 31 deletions(-)

Applied.
