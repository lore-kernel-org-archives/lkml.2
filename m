Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2GOPgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 11:36:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60031 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab2GOPfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 11:35:50 -0400
MIME-Version: 1.0
In-Reply-To: <1342356246-17233-1-git-send-email-cruz@massive-dynamics.biz>
References: <1342356246-17233-1-git-send-email-cruz@massive-dynamics.biz>
Date: Sun, 15 Jul 2012 17:35:49 +0200
Message-ID: <CAFLxGvyKjJkRbjBbReowwM5Ljf+Vs9XcaNEMhA00rJQgwrFQYw@mail.gmail.com>
Subject: Re: [PATCH] Checkpatch fixes for drivers/staging/panel/panel.c
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Cruz Julian Bishop <cruz@massive-dynamics.biz>
Cc: greg@kroah.com, willy@meta-x.org, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 2:44 PM, Cruz Julian Bishop
<cruz@massive-dynamics.biz> wrote:
>  #if 0
> -       printk(KERN_DEBUG
> -              "entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
> +       pr_debug("entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
>                phys_prev, phys_curr);
>  #endif

Instead of following checkpatch.pl's suggestions in a completely
brain-dead manner you should better read the code.
The printk() is under a "#if 0", so the whole block is useless anyway...

-- 
Thanks,
//richard
