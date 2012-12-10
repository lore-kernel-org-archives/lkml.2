Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2LJJzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:55:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34133 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2LJJzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:55:06 -0500
MIME-Version: 1.0
In-Reply-To: <1354934194-28213-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1354934194-28213-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Date: Mon, 10 Dec 2012 10:55:04 +0100
Message-ID: <CACRpkdbjWz99SEV1gZKiNhiCS2k_CT+oznorNDpw=hvyF49Gkg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: add TS-5500 DIO blocks support
From: Linus Walleij <linus.walleij@linaro.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 8, 2012 at 3:36 AM, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:

> Technologic Systems TS-5500 provides digital I/O lines exposed through
> pin blocks. On this platform, there are three of them, named DIO1, DIO2
> and LCD port, that may be used as a DIO block.
>
> The TS-5500 pin blocks are described in the product's wiki:
> http://wiki.embeddedarm.com/wiki/TS-5500#Digital_I.2FO
>
> This driver is not limited to the TS-5500 blocks. It can be extended to
> support similar boards pin blocks, such as on the TS-5600.
>
> This patch is the V2 of the previous https://lkml.org/lkml/2012/9/25/671
> with corrections suggested by Linus Walleij.
>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>

Thanks Vivien, it's looking *very* nice and clean now, so patch applied!

It's perfectly OK this late before the merge window since it's a new driver.

Yours,
Linus Walleij
