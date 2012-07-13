Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030796Ab2GMSAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:00:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63366 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab2GMSAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:00:37 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.44.123]
In-Reply-To: <47AF0F55-39D1-4B7E-BE0E-D2395989322D@studiofuga.com>
References: <1341936444-3094-1-git-send-email-fuga@studiofuga.com>
 <CAK=Wgbaf0On3teqOw1myqkS4Dei3Vw2Zn=0xfOv-YiNUjFr0fg@mail.gmail.com>
 <485F7F7C-2D0C-4B14-8A46-D42C9F8ED4E4@studiofuga.com> <CAK=WgbZFHzHLxQfoWW4Cz_PpBCzER75KCd=C3WS-7w_LryKuQA@mail.gmail.com>
 <47AF0F55-39D1-4B7E-BE0E-D2395989322D@studiofuga.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 13 Jul 2012 21:00:16 +0300
Message-ID: <CAK=WgbaTrjSPqEKKt+bt0uD1x+yNXxRZfJUGZjjMnWGV0aAV3Q@mail.gmail.com>
Subject: Re: [PATCH] rpmsg bus subsys_initcall initialization ordering
To: Federico Fuga <fuga@studiofuga.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Federico,

On Wed, Jul 11, 2012 at 10:14 AM, Federico Fuga <fuga@studiofuga.com> wrote:
> it triggers a BUG() in drivers/base/driver.c line 169

Thanks for sharing this; it definitely makes sense now.

> The subsys_initcall indeed solve this issue

I agree. I'll take it, but will change the commit log to make it
omaprpc-agnostic.

Thanks,
Ohad.
