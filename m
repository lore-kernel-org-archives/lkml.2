Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935080Ab2JXOxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:53:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39766 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934961Ab2JXOxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:53:14 -0400
Date: Wed, 24 Oct 2012 15:53:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: Standardise capability type
Message-ID: <20121024145308.GE3537@gmail.com>
References: <1351084664-30526-1-git-send-email-lee.jones@linaro.org>
 <201210241321.26878.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201210241321.26878.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Arnd Bergmann wrote:

> On Wednesday 24 October 2012, Lee Jones wrote:
> > 
> > There are discrepancies with regards to how MMC capabilities
> > are carried throughout the subsystem. Let's standardise them
> > to elevate any confusion.
> > 
> > Cc: Chris Ball <cjb@laptop.org>
> > Cc: linux-mmc@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Why make it "unsigned long" then? I think that adds to the
> confusion because it's sometimes 32 bits and sometimes 64 bits,
> depending on the CPU. Since it's a bitmask, I would suggest
> using u32 to make the size explicit.

I'm not sure that it leaves any confusion. It perhaps wastes a little
space on 64bit architectures, but that also applies to a great deal
of other bitmasks floating around.

I can do it if you feel that passionate about it, but it's a bigger
job to hunt down all occurrences and change them over. I only felt
strongly enough about it to craft this patch because I noticed the
inconsistency as I created new populate caps for OF functionality.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
