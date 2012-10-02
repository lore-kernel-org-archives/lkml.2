Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2JBIVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:21:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35270 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab2JBIVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:21:11 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.255.235]
In-Reply-To: <1348846506-9670-1-git-send-email-emilgoode@gmail.com>
References: <1348846506-9670-1-git-send-email-emilgoode@gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 2 Oct 2012 10:20:51 +0200
Message-ID: <CAK=WgbaNz_20AoKCsw53f5UiG+5AhvpnFV-aiJTMUpO5+u1bnA@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: Fix use of format specifyer
To: Emil Goode <emilgoode@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 5:35 PM, Emil Goode <emilgoode@gmail.com> wrote:
> The dma_addr_t type can be eigher u32 or u64 depending on
> the configuration. We should use a format specifyer for the
> larges type and explicitly cast to it.
>
> Sparse warnings:
> drivers/remoteproc/remoteproc_core.c:234:2: warning:
>         format ‘%x’ expects argument of type ‘unsigned int’,
>         but argument 6 has type ‘dma_addr_t’ [-Wformat]
>
> drivers/remoteproc/remoteproc_core.c:596:2: warning:
>         format ‘%x’ expects argument of type ‘unsigned int’,
>         but argument 5 has type ‘dma_addr_t’ [-Wformat]
>
> drivers/remoteproc/remoteproc_core.c:634:3:
>         warning: format ‘%x’ expects argument of type ‘unsigned int’,
>         but argument 5 has type ‘dma_addr_t’ [-Wformat]
>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Applied (after fixing some commit log typos), thanks.
