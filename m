Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0HXDa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 23:30:26 -0400
Received: from mail.perches.com ([173.55.12.10]:1310 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab0HXDaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 23:30:23 -0400
Date: Mon, 23 Aug 2010 20:30:14 -0700 (PDT)
From: Joe Perches <joe@perches.com>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
cc: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>
Subject: RE: [PATCH 2/2] drivers/serial/bfin_5xx.c: Use pr_<level> and pr_<fmt>
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA06C35A09@chinexm1.ad.analog.com>
Message-ID: <Pine.LNX.4.30.1008232025260.31237-100000@mail.perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Zhang, Sonic wrote:
> >Also fix typo of length.
> >Signed-off-by: Joe Perches <joe@perches.com>
> >-		pr_info("Unable to attach BlackFin UART Modem "
> >-			"Status interrupt.\n");
> >+		pr_info("Unable to attach BlackFin UART Modem
> >Status interrupt\n");
> I don't this this change is necessary.

Linus once said he doesn't like splitting
format lines because it makes grep more
difficult.

http://lkml.org/lkml/2009/12/17/229

> How about following style?
>
> 			pr_warning( "STOP bits other than 1 is not "
> 				"supported in case of anomaly
> 05000231.\n");

Fix it up as you prefer.

cheers, Joe

