Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab0CXWnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:43:03 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:46664 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0CXWnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OahX9cv//qcfVNVOzkXCVzTN0+5MMlxGeZoge48FTGll7E9qNxrCk+xYRiUkSLWOOr
         +TJS42HI6H8WDKhHtbZ3pVTsizUVy78zU9myF30w67O9X5l4zD3hnVd8UB1aqAHmkj/G
         h6L3RRA5/9IlH39xvC+JxDrLE6mbvHwECdk9Y=
MIME-Version: 1.0
In-Reply-To: <e9c3a7c21003241537j1fc2cb4cjfbea205b904ec852@mail.gmail.com>
References: <1268473365-30197-1-git-send-email-linus.walleij@stericsson.com>
	 <e9c3a7c21003241537j1fc2cb4cjfbea205b904ec852@mail.gmail.com>
Date: Wed, 24 Mar 2010 15:42:59 -0700
X-Google-Sender-Auth: c434cbc28b6aa984
Message-ID: <e9c3a7c21003241542h3cef7417pc2af6a0dbe278beb@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: U300 platform configuration
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 3:37 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sat, Mar 13, 2010 at 2:42 AM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
>> This completes the DMA40 support with the platform-specific
>> configuration for U8500/DB8500.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>> ---
>>  arch/arm/mach-ux500/board-mop500.c           |  222 +++++++++++++++++++++
>>  arch/arm/mach-ux500/clock.c                  |    4 +-
>>  arch/arm/mach-ux500/include/mach/hardware.h  |   16 ++-
>>  arch/arm/mach-ux500/include/mach/ste_dma40.h |  268 ++++++++++++++++++++++++++
>>  arch/arm/mach-ux500/ste-dma40-db8500.h       |  133 +++++++++++++
>>  5 files changed, 640 insertions(+), 3 deletions(-)
>>  create mode 100644 arch/arm/mach-ux500/include/mach/ste_dma40.h
>
> Quick comment, this file needs to be moved into the first patch
> otherwise there is bisection/build breakage.
>
> drivers/dma/ste_dma40.c:17:28: error: mach/ste_dma40.h: No such file
> or directory

Also, this patch collides with latest git.  I'm basing async_tx/next
on 2.6.34-rc2.

--
Dan
