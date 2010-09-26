Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0IZKbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 06:31:41 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53057 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab0IZKbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 06:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FnvNTJOL603baz4yH5xm/M/R6vx7KtG+18AoAbMdv37l8HG0NZIlAKMEfMFUlHoONm
         LzzpdBPaAVapdDnRLFD9dPzyylNZ/aVgFpFdxTuD8C0yOLOp1BFvJPck0MNTh8JWfwe+
         REtAgSXkigzR1wRGRmpRq606dh3Ra+vIrTlWU=
MIME-Version: 1.0
In-Reply-To: <40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
References: <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
	<036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com>
	<ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
	<b3e2061e1e6703f7b84c0484030e07de6000546a.1285355033.git.mfm@muteddisk.com>
	<e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
	<70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
	<40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
Date: Sun, 26 Sep 2010 14:31:38 +0400
Message-ID: <AANLkTik1ngVjK9ZObC_BfS6Cb-b5trcCAGk2i26TgEz_@mail.gmail.com>
Subject: Re: [PATCH 07/24] ieee802154: change to new flag variable
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: matt mooney <mfm@muteddisk.com>
Cc: kernel-janitors@vger.kernel.org, Sergey Lapin <slapin@ossfans.org>,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/10, matt mooney <mfm@muteddisk.com> wrote:
> Replace EXTRA_CFLAGS with ccflags-y.
>
> Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

> ---
>  drivers/ieee802154/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)


-- 
With best wishes
Dmitry
