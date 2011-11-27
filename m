Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1K0ST7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 13:19:59 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51131 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1K0ST6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 13:19:58 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1322369586.2522.3.camel@phoenix>
References: <1322369586.2522.3.camel@phoenix>
Date: Sun, 27 Nov 2011 10:19:57 -0800
Message-ID: <CAOesGMjM+WpQz=Gb8UKA_QD+DuLdwwskPskD8rdujf9B1sCqrA@mail.gmail.com>
Subject: Re: [PATCH] pcmcia: convert drivers/pcmcia/* to use module_platform_driver()
From: Olof Johansson <olof@lixom.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Marc Zyngier <maz@misterjones.org>, Ralf Baechle <ralf@linux-mips.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pcmcia@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 8:53 PM, Axel Lin <axel.lin@gmail.com> wrote:
> This patch converts the drivers in drivers/pcmcia/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
> Cc: Manuel Lauss <manuel.lauss@gmail.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Marc Zyngier <maz@misterjones.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
