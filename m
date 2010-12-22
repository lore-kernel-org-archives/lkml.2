Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0LVOmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:42:31 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:40622 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab0LVOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:42:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w1GvvlyiHJmQKNuCH1Fj2XJ50XeON514S+lmKfrqwnH9MLUARrmzcieefQDiToWEi0
         wJN4OjaB3Bf4LlITbCxdq4daXWVOX6gFv2OsZb5WYo0jUAHJZPv1DUZf79eJicmyG0Cy
         LECzniaFn8PMz7Z2lXPRpNm9Vhe2EkPKm8Rmw=
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Lunz <lunz@acm.org>
Cc: Anatolij Gustschin <agust@denx.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <20101220140454.GA26229@falooley.org>
References: <20101207072919.GA8511@falooley.org>
	 <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
	 <20101207182012.GA10546@falooley.org> <1292343878.2538.80.camel@localhost>
	 <20101214195124.GA6010@falooley.org> <20101216230110.65156c55@wker>
	 <20101217042759.GA3148@falooley.org> <1292777276.2140.1.camel@koala>
	 <20101219190720.GA16710@falooley.org> <1292844216.13362.19.camel@koala>
	 <20101220140454.GA26229@falooley.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 16:40:42 +0200
Message-ID: <1293028842.12773.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 09:04 -0500, Jason Lunz wrote:
> On Mon, Dec 20, 2010 at 01:23:36PM +0200, Artem Bityutskiy wrote:
> > Ok, could you please re-sent the final patch with the commit message
> > etc?
> 
> Sure, here's everything as a single patch.
> 
> ------------------------------------->8
> Allow parts of drivers/mtd to compile on uml by pushing the HAS_IOMEM
> dependencies down closer to the parts of mtd that actually need it.
> This allows enough of mtd to build to let jffs2 be used on uml.
> 
> Signed-off-by: Jason Lunz <lunz@acm.org>

OK, taken this one, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

