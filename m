Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab2JVIyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:54:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39440 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2JVIyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:54:35 -0400
MIME-Version: 1.0
In-Reply-To: <20121019180232.GD3375@kroah.com>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
	<1350477107-26512-3-git-send-email-stigge@antcom.de>
	<20121017190520.GC25996@kroah.com>
	<507FD4EB.1080204@antcom.de>
	<20121019180232.GD3375@kroah.com>
Date: Mon, 22 Oct 2012 10:54:34 +0200
Message-ID: <CACRpkdYNwj=nr8Q8D73rtN-4_ciUM8nJuUMExTuMtcJAFGB=CA@mail.gmail.com>
Subject: Re: [PATCH RFC 02/15 v5] gpio: Add sysfs support to block GPIO API
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Roland Stigge <stigge@antcom.de>, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 8:02 PM, Greg KH <gregkh@linuxfoundation.org> wrote:

> We used to have problems with attributes removing/adding devices or
> attributes from their callbacks, but that has been fixed up now, and the
> fact that the other gpio code works this way is good enough precedence
> to keep me from objecting to it.

OK thanks I get this now too...

Yours,
Linus Walleij
