Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab0HOPzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:55:44 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59978 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab0HOPzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AQp4jaH1Sk2mUqc8Xj9cbxekRGieEGz0DjwXYDTanz+qfr0ufSZolkdJ+UJjliMFPk
         XWo/I4S4xbbDm2MWaUfvqNfRQBZek0B/MqwyDvIdCzUYvGNI9acBjJZr3ulV87+uXCOh
         +ivvr+S70ngSF1nifZly15I7DojOb9eicBdKs=
MIME-Version: 1.0
In-Reply-To: <33A307AF30D7BF4F811B1568FE7A9B18188E2CA0@EXDCVYMBSTM006.EQ1STM.local>
References: <1281793444.2974.5.camel@phoenix>
	<33A307AF30D7BF4F811B1568FE7A9B18188E2CA0@EXDCVYMBSTM006.EQ1STM.local>
Date: Sun, 15 Aug 2010 14:03:59 +0200
Message-ID: <AANLkTikyyw4H=mXp5oY3pWtQa0F1ObR4a94K9QGNMyQn@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500 - fix the logic to remove already
 registered regulators in error path
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/14 Sundar R IYER <sundar.iyer@stericsson.com>:

> BTW, could you also include the AB3100 as well into this patch? I derived it from
> the AB3100 implementation.

Aha the same thing for AB8500, yeah I confess it is probably my coding
mistake replicated so
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
on this one too then!

Thanks.
Linus Walleij
