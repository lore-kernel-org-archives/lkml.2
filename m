Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab0FBWpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:45:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52590 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab0FBWpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A9EtH66o7M9LIklBs2+7jgDvkpfvcTjrNPNpR3wSEkk13zXGnPC3+eg7zo3GKepUJL
         sfNZEbvU290XYPGJf1Po5Sl9QH1BNdywl6Uh3q2SlwRhd5ptUBXFuIHR5YDQj7UejzwA
         6qt6ArT0N6dXiIUvgZP6UDU4FX55iyj5Yy4Wc=
MIME-Version: 1.0
In-Reply-To: <1275505397-16758-4-git-send-email-lars@metafoo.de>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
	<1275505397-16758-4-git-send-email-lars@metafoo.de>
Date: Thu, 3 Jun 2010 08:15:22 +0930
Message-ID: <AANLkTimVM637peyrPP7dZ3Uy2S-3DAEXspGi-FONcW6p@mail.gmail.com>
Subject: Re: [RFC][PATCH 03/26] MIPS: JZ4740: Add clock API support.
From: Graham Gower <graham.gower@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2010 04:32, Lars-Peter Clausen <lars@metafoo.de> wrote:

> +       {
> +               .name = "dma",
> +               .parent = &jz_clk_high_speed_peripheral.clk,
> +               .gate_bit = JZ_CLOCK_GATE_UART0,
> +               .ops = &jz_clk_simple_ops,
> +       },

Presumably this should be JZ_CLOCK_GATE_DMAC.

-Graham
