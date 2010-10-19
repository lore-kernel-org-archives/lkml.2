Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab0JSKsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:48:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46428 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269Ab0JSKsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:48:01 -0400
To: npiggin@kernel.dk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20101019034656.201381145@kernel.dk> (npiggin@kernel.dk)
Subject: Re: [patch 07/35] fs: icache lock i_state
References: <20101019034216.319085068@kernel.dk> <20101019034656.201381145@kernel.dk>
Message-Id: <E1P89jV-0006B6-Go@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 19 Oct 2010 12:47:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, npiggin@kernel.d wrote:
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:18:58.000000000 +1100
> +++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:36.000000000 +1100
> @@ -288,10 +288,12 @@

The function name here helps review a bit.  If you are using quilt add
"export QUILT_DIFF_OPTS=-p" to .quiltrc.

Thanks,
Miklos
