Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1J1Mme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:42:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33552 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab1J1Mmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:42:33 -0400
Date: Fri, 28 Oct 2011 13:42:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mike Frysinger <vapier@gentoo.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] asm-generic/gpio.h: merge basic gpiolib wrappers
Message-ID: <20111028124200.GU19187@n2100.arm.linux.org.uk>
References: <1319528012-19006-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1319720503-3183-1-git-send-email-vapier@gentoo.org> <20111027131124.GK19187@n2100.arm.linux.org.uk> <CAJaTeTp71t0BYsEpDu07BE5ox2FBAiH7xEQqjhb=6QadrsQGAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaTeTp71t0BYsEpDu07BE5ox2FBAiH7xEQqjhb=6QadrsQGAQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 02:15:00PM +0200, Mike Frysinger wrote:
> On Thu, Oct 27, 2011 at 15:11, Russell King - ARM Linux wrote:
> > This is extremely dangerous.  Consider for example this code
> > (see ARM mach-davinci's gpio.h):
> 
> it's interesting you highlight davinci.  if i'm reading things
> correctly, the current davinci code is broken today and my v2 proposed
> patch actually fixes it.

That looks like an error in patch 5f3fcf9649dbb010ccac41259d04147775ec8fc2
(ARM: 7040/1: mach-davinci: break out GPIO driver specifics) which does
this:

-#define __ARM_GPIOLIB_COMPLEX

Linus, can you send a fix?
