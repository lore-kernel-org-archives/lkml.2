Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab1JXMHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:07:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43494 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932132Ab1JXMHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:07:09 -0400
Date: Mon, 24 Oct 2011 14:07:06 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: Provide a definition of struct gpio for the
 stub gpiolib
Message-ID: <20111024120706.GD6148@opensource.wolfsonmicro.com>
References: <1319455649-4916-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20111024120120.GO8708@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024120120.GO8708@ponder.secretlab.ca>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 02:01:20PM +0200, Grant Likely wrote:
> On Mon, Oct 24, 2011 at 01:27:29PM +0200, Mark Brown wrote:
> > This makes the stub gpio_request_array() much more usable as drivers can
> > declare struct gpio variables.

> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> Shouldn't this patch remove the definition from
> include/asm-generic/gpio.h at the same time?

Both the original forward declaration and the new definition are within
the !GPIOLIB case of the #defines, it's just a minimal patch moving the
undefined forward declaration to a defintion.  I didn't want to worry
about reading the individual users to figure out if they had separate
defintions separately to the work to get them all moved over to gpiolib.
