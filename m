Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2ENUHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:07:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33388 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab2ENUHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:07:05 -0400
MIME-Version: 1.0
In-Reply-To: <1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com>
References: <1336772086-17248-1-git-send-email-ddaney.cavm@gmail.com>
	<1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 14 May 2012 22:07:05 +0200
Message-ID: <CACRpkdaAeMV2yCNNP+e0BKaXEeZon2CKJs-TskVH5CVWXuqyiA@mail.gmail.com>
Subject: Re: [PATCH 2/2] spi: Add SPI master controller for OCTEON SOCs.
From: Linus Walleij <linus.walleij@linaro.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net, linux-mips@linux-mips.org,
        David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:34 PM, David Daney <ddaney.cavm@gmail.com> wrote:

> +       mpi_cfg.u64 = 0;
> +       mpi_cfg.u64 |= p->cs_enax;
> +       if (mpi_cfg.u64 != p->last_cfg) {

But now I see why this 64bit is so clever. Forget the comment on 1/2!
This has a certain elegance to it that I just learned to appreciate.

Yours,
Linus Walleij
