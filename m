Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0ITHyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:54:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45129 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab0ITHyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Dqow5i6nLEcebMWtx8PQe4qDr1jaeMfP5bFFk3zi5hjYVFA3WyzFRQJzlCHcwuqMeI
         57oEsSQzG7zKGgziyPk9gE/XL1e/lvxEAHDLDwwEIW+hxAkopY1PdwN9lH9bBndnhdto
         BxW6x/4CZWGKIMk9G7xKMQPQVKaIc0O0Nntog=
Subject: Re: [PATCH v4] mtd: nand: Expand nand_ecc_layout, deprecate ioctl
 ECCGETLAYOUT
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Brian Norris <computersforpeace@gmail.com>
Cc: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Sneha Narnakaje <nsnehaprabha@ti.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>
In-Reply-To: <4C96FF10.2010805@gmail.com>
References: <4C5CA4A1.1040000@broadcom.com>
	 <1282154806-9420-1-git-send-email-norris@broadcom.com>
	 <4C6DD170.1060807@renesas.com>  <4C6E9C23.6060703@broadcom.com>
	 <1282646703.24044.162.camel@localhost>  <4C746DE0.7000104@gmail.com>
	 <1283163647.12995.43.camel@brekeke> <1284830690.1721.3.camel@brekeke>
	 <4C96FF10.2010805@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 10:52:40 +0300
Message-ID: <1284969160.2286.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-19 at 23:28 -0700, Brian Norris wrote:
> >> Oh, does it mean you will stop loving MTD and we won't see steady flow
> >> of improvements for you? :-( BTW, I think you have been doing great job
> >> - MTD subsystem needs love badly!
> 
> No, this doesn't mean I will stop loving MTD, although as may be readily
> apparent by my delay, I may work a bit slower :) In fact, I will
> probably be picking up some more work shortly.

Nice :-)

> From the context, I assume you meant include/mtd/mtd-abi.h, not
> linux/mtd/mtd.h; am I correct?

Probably yes :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

