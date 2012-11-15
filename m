Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767642Ab2KOLr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:47:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993197Ab2KOLrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:47:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mmc: Standardise capability type
Date: Thu, 15 Nov 2012 11:47:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
References: <1352896551-17948-1-git-send-email-lee.jones@linaro.org> <CACRpkdZ+V1aiQ-c62v9jdv93wMGu9hrSnXj_a9jx3uOTbot44A@mail.gmail.com>
In-Reply-To: <CACRpkdZ+V1aiQ-c62v9jdv93wMGu9hrSnXj_a9jx3uOTbot44A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211151147.14858.arnd@arndb.de>
X-Provags-ID: V02:K0:A37YLo/PaxnWphlfF/UsP/pXnfIiUol4RjIBGsARxIP
 8xZvfytohzVPCnKwHfflK2zYbu4N3rTGtw2F8R7bSOp/HWIxVq
 0IIhTX90PfjbMhcKXQ52EPeYh7h0RfCQlvVhz/o42pPERlxtVF
 2tJTgGYSHBGyD5pLBjFzQY4NhQlY4296zfYeJhM07BTAJoyh3C
 CytXRRFmKUTs3yZ0AAc4E2gPyciO9C5MOXame7+852zSJqQeUB
 mFn0vSXsihu+lPmrkRaSILHQIypl1zNEk+kFmIx+Q74YdkhBYh
 j+BLBCKqXUWbwwNxkXMXe8cS/kgl7FaLbE7rMCou8bq2EXE4LZ
 ZNbNkwyLyVABAwnp7NZ8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Linus Walleij wrote:
> 
> On Wed, Nov 14, 2012 at 1:35 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > There are discrepancies with regards to how MMC capabilities
> > are carried throughout the subsystem. Let's standardise them
> > to elevate any confusion.
> >
> > Cc: Chris Ball <cjb@laptop.org>
> > Cc: linux-mmc@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Looks good to me, and these are obviously
> u32 bitfields by design, so:
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
