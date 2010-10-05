Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab0JETzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:55:53 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59803 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab0JETzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uVq7bHJNgz39D4oqvUKWsXiT1TgVdDchiquJjky7VPSPiCNJtd0vNN997cwlyNC3HV
         c4kyiJ060HHZcqP5UiKCJQEYIkbyWkDkLEGMlo4J9I49OZob3ItTIOQagPSku7oCeHQY
         J7CYNfSWiabKGzrXs/KVXxXTbyTcRobIvMgnY=
MIME-Version: 1.0
In-Reply-To: <1286307715-12276-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1286307715-12276-1-git-send-email-Dinh.Nguyen@freescale.com>
Date: Tue, 5 Oct 2010 21:55:51 +0200
Message-ID: <AANLkTim+WNx1B860AgHeP_X2u7HRC3=40j3FKgAg_BXf@mail.gmail.com>
Subject: Re: [PATCHv3] ARM: imx: Add iram allocator functions
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, r.schwebel@pengutronix.de,
        valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
        amit.kucheria@canonical.com, xiao-lizhang@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/5  <Dinh.Nguyen@freescale.com>:

> Add iram allocation functions using GENERIC_ALLOCATOR. The
> allocation size is 4KB multiples to guarantee alignment. The
> idea for these functions is for i.MX platforms to use them
> to dynamically allocate IRAM usage.

Neither here...

> +config IRAM_ALLOC
> +       bool "Enable IRAM allocator"
> +       select GENERIC_ALLOCATOR
> +       help
> +         Select this to have access to generic IRAM allocation functions that
> +         use the GENERIC_ALLOCATOR.  The allocation size is 4KB multiples to
> +         guarantee alignment. The idea for these functions is for i.MX platforms
> +         to use them to dynamically allocate IRAM usage.

Nor here is is explained what an IRAM is.

What is it? Is this yet another fancy name for on-chip-memory?

And why I? = Initial? Interrupt? ...?

Yours,
Linus Walleij
