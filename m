Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2HaJoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:44:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48441 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2HaJop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:44:45 -0400
Date: Fri, 31 Aug 2012 10:44:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/8] irqdomain: Take interrupt-parent property into
 account if specified
Message-ID: <20120831094434.GF13298@gmail.com>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdZMoisfUD_NSkVy2w-jZVUDGn0E8LmvKSWnJ0YRGZO-tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZMoisfUD_NSkVy2w-jZVUDGn0E8LmvKSWnJ0YRGZO-tQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 10:19:08AM +0200, Linus Walleij wrote:
> On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > irq_find_host() currently ignores the 'interrupt-parent' property
> > even if it's specified in the Device Tree. Meaning that a node can
> > match to a domain in its hierarchy even if it doesn't belong to it.
> > By searching for the parent first using of_irq_find_parent() we
> > insist that the 'interrupt-parent' property is taken into account
> > ensuring a greater chance of returning the correct domain.
> >
> > CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > CC: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> This (with 1/8) is the right solution. Thanks, and I think
> Mark may want to look at this too since I recognize he asked
> you to work in this direction.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Rob, did this get your Ack too?

Ben, Grant, Mark, would you like to take a look also?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
