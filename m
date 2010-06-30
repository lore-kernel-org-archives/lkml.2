Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab0F3WDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:03:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39273 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab0F3WDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:03:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hTgX3Ebrgb+Vb9eMBDuofYXTFEVZuC/5LPPpaoSAF55u2f0CMXTM7Thi7oFtWC07Iz
         Ccfp5GW7sPuJvlJgIy2Wx1ox+ooELbRfHyVhm9bDF1IB4VvTUMeDURghdLLVrmn+AHY/
         p15AiclckdSzugT2WTrJ3y5UC7B2Xi+K/kbOQ=
MIME-Version: 1.0
In-Reply-To: <41be9a8afe8951b4ad23d43fcb57aca9a662cf43.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
	<41be9a8afe8951b4ad23d43fcb57aca9a662cf43.1277911346.git.siccegge@cs.fau.de>
Date: Thu, 1 Jul 2010 00:03:29 +0200
Message-ID: <AANLkTinHA5PsD_5i-YgRNSNzddsqc1JojDN5AvC9ot8C@mail.gmail.com>
Subject: Re: [PATCH 33/33] Removing dead MACH_U300_USE_I2S_AS_MASTER
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/30 Christoph Egger <siccegge@cs.fau.de>:

> MACH_U300_USE_I2S_AS_MASTER doesn't exist in Kconfig, therefore
> removing all references for it from the source code.
>
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

I remember the pain of writing that code, but until I get around to merge that
ancient driver I see no point in keeping it around, so:
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
