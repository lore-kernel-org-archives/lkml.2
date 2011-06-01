Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1FAPGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:06:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44542 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1FAPGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TZC9tNIdqWDgIX1QUkydJPp+LcyJLFTK8vaJgLQzk9/7k98OQd6PfZRGsKO1S8ROnF
         MIuxCzpZ7LF53bEhpyst69P0p86i2dPtfEFRIQcwk2qwV3Lq1jrxgSwl0UbMl5oFdDHo
         kLUvdVjGrfuD7r1SL2ZuGlEEX90ELkaRXcM0o=
Subject: Re: [PATCH] ATMEL, AVR32: inline nand partition table access
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <BANLkTi=s4kGg5NKrzNs1nu8S00Ue_Zv8vQ@mail.gmail.com>
References: <1306676962-22308-1-git-send-email-dbaryshkov@gmail.com>
	 <1306935129.1097.3.camel@hcegtvedt.norway.atmel.com>
	 <BANLkTi=s4kGg5NKrzNs1nu8S00Ue_Zv8vQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 18:01:49 +0300
Message-ID: <1306940509.4405.121.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 18:54 +0400, Dmitry Eremin-Solenikov wrote:
> On 6/1/11, Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:
> > On Sun, 2011-05-29 at 17:49 +0400, Dmitry Eremin-Solenikov wrote:
> >> Currently atmel_nand driver used by AT91 and AVR32 calls a special
> >> callback
> >> which return nand partition table and number of partitions. However in all
> >> boards this callback returns just static data. So drop this callback and
> >> make atmel_nand use partition table provided statically via platform_data.
> >>
> >> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> >
> > Thanks for this update, always nice seeing code being optimized. I
> > really can't recall why it was made like this in the first place...
> >
> > For the AVR32 related parts:
> >
> > Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> >
> > <snipp diff>
> >
> > Will this go through the linux-mtd tree (since it spans two archs) or
> > should it go through an arch tree?
> 
> On one hand, I'd prefer for this to go through the linux-mtd, if noone objects,
> as I'd also like to submit several (a pile) patches cleaning up mtd
> partitioning, which would depend on this.
> 
> OTOH, I think there will be a cleanup of AT91 platform, which would bring
> lot's of conflicts with this patch, if it goes through linux-mtd.

Meanwhile, while you are thinking, I've put this patch to the l2-mtd-2.6
tree. Please, let me know if you decide to take a non-mtd path - then
I'll drop it.

And if you want to see this in linux-next - ping dwmw2.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

