Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab2FUIxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:53:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52575 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016Ab2FUIxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:53:45 -0400
Date: Thu, 21 Jun 2012 01:53:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: dgdunix@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: gpio_keys_polled.c and DT
Message-ID: <20120621085340.GE2193@core.coreip.homeip.net>
References: <4FE0946B.8030201@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE0946B.8030201@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Tue, Jun 19, 2012 at 05:02:03PM +0200, Roland Stigge wrote:
> Hi,
> 
> as far as I can see, gpio_keys_polled.c currently doesn't support DT
> initialization. Is there a plan in this regard?
> 
> Rather than duplicating the respective code from gpio_keys.c, maybe
> gpio_keys.c could be changed to support a polled mode also? This way,
> gpio_keys_polled.c could be removed.

We had several attempts at gpio_keys and adding a polled mode and we
ended up with the driver getting too complex and having unwanted
dependencies. At the moment I believe that the split between gpio_keys.c
and gpio_keys_polled.c is justified even it it may lead to certain code
duplication.

However, if DT bindings are really the same we could split them off into
a separate library module used by both drivers.

Thanks.

-- 
Dmitry
