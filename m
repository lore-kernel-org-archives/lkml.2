Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2DKJHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:07:11 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:54468 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2DKJHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:07:08 -0400
Date: Wed, 11 Apr 2012 11:06:57 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Richard Weinberger <richard@nod.at>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, benh@kernel.crashing.org
Subject: Re: [PATCH] powerpc: 512x: Fix mpc5121_clk_get()
Message-ID: <20120411110657.1deaad93@wker>
In-Reply-To: <1332788489-27435-1-git-send-email-richard@nod.at>
References: <1332788489-27435-1-git-send-email-richard@nod.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 21:01:29 +0200
Richard Weinberger <richard@nod.at> wrote:

> If try_module_get() fails, mpc5121_clk_get() might return
> a wrong clock.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/powerpc/platforms/512x/clock.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)

Applied, thanks.

Anatolij
