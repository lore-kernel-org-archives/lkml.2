Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2HaKgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 06:36:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64015 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2HaKgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 06:36:42 -0400
Date: Fri, 31 Aug 2012 11:36:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, w.sang@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik
 I2C driver
Message-ID: <20120831103633.GA5569@gmail.com>
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
 <1345734087-21803-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdapY3JvZmLxK7dX917O-E+aDgVE9ELnysjqAyETXMZHNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdapY3JvZmLxK7dX917O-E+aDgVE9ELnysjqAyETXMZHNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 04:42:49PM -0700, Linus Walleij wrote:
> On Thu, Aug 23, 2012 at 8:01 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Here we apply the bindings required for successful Device Tree
> > probing of the i2c-nomadik driver.
> >
> > Cc: linux-i2c@vger.kernel.org
> > Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

I'm assuming I still need Wolfram's Ack on this?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
