Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab0LSRB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 12:01:28 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:64331 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab0LSRB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 12:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u8TpHPo75Tqay9wYmYTZvXsGKn3OwXjIc3R/LrD97dJnQOsANwtMh8c5mhreN7xtWQ
         cu2h1gcdA4DBd4wQPrUQUYPBSIDY1QLCmwXFVuQ7wN03BkLGUFcEFZ4CuMV0PzOnJS8X
         M1hz3S/Lt8/rYPys65BFly5UAXQawBx3oOkYw=
Subject: Re: [PATCH] MTD: m25p80: add debugging trace in sst_write()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1292414372-17085-1-git-send-email-nicolas.ferre@atmel.com>
References: <1292414372-17085-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 19:00:55 +0200
Message-ID: <1292778055.13362.8.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 12:59 +0100, Nicolas Ferre wrote:
> Add a DEBUG(MTD_DEBUG_LEVEL2, ..) trace at beginning of sst_write() function as
> it is done in m25p80_write() function.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

So do you do this only becaus it is done in m25p80_write()? This is what
the commit message suggests... Have you found these DEBUG macros useful
for you? (I never found them any useful).

Anyway, I've put this to my l2-mtd-2.6.git tree, thanks.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

