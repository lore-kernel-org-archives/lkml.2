Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab2LTQv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:51:57 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:49462 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2LTQvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:51:51 -0500
Date: Thu, 20 Dec 2012 16:51:50 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Wolfram Sang <w.sang@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PULL REQUEST] i2c-embedded for 3.8
In-Reply-To: <CA+55aFyV5ROO-Zy4UxhXx0Lu6biyBzmrre=NY1x0yx7tK+Lz8g@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1212201650430.28579@utopia.booyaka.com>
References: <20121218234150.GA32374@pengutronix.de> <CA+55aFyV5ROO-Zy4UxhXx0Lu6biyBzmrre=NY1x0yx7tK+Lz8g@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012, Linus Torvalds wrote:

> But quite frankly, the thing is ugly as heck, and I hope it could just 
> be deleted.

With luck we'll be able to get rid of it in 3.9, once the underlying issue 
with the I2C driver is tracked down.

- Paul
