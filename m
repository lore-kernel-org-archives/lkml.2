Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2B0VHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:07:08 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51877 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006Ab2B0VHH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:07:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.182.44.68 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <4F4BE150.3000903@gmail.com>
References: <4F4BE150.3000903@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 27 Feb 2012 14:06:46 -0700
X-Google-Sender-Auth: GkMqQ1DGAYLxLrCzoXRs4C7kPXc
Message-ID: <CACxGe6uzY4z22tS-Z7oNT7NTiwgXLxkzAi=zEydf2+8OhwZX7A@mail.gmail.com>
Subject: Re: [PULL] DT fixes for 3.3
To: Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 1:02 PM, Rob Herring <robherring2@gmail.com> wrote:
> Grant,
>
> Please pull these few fixes and doc updates for 3.3.

Merged, thanks.

g.


>
> Rob
>
> The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:
>
>  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)
>
> are available in the git repository at:
>  git://sources.calxeda.com/kernel/linux.git fixes-for-grant
>
> Baruch Siach (1):
>      of/mdio: fix fixed link bus name
>
> Danny Kukawka (1):
>      of/fdt.c: asm/setup.h included twice
>
> Jamie Iles (1):
>      of: add picochip vendor prefix
>
> Tobias Klauser (1):
>      doc: dt: Fix broken reference in gpio-leds documentation
>
>  Documentation/devicetree/bindings/gpio/led.txt     |    6 +++---
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  drivers/of/fdt.c                                   |    1 -
>  drivers/of/of_mdio.c                               |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
