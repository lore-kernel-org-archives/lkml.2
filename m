Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1JUK2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 06:28:30 -0400
Received: from smtp.nokia.com ([147.243.128.24]:51947 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab1JUK23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 06:28:29 -0400
Subject: Re: [RFC PATCHv5 0/7] HSI framework and drivers
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Reichel <sre@debian.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, govindraj.ti@gmail.com,
        pawel.szyszuk@stericsson.com, sjur.brandeland@stericsson.com,
        peter_henn@gmx.de
In-Reply-To: <CACRpkdYBFGp4+oFUZvXn-wpUk0fmLiKixchQKcFo9XTDW=51+g@mail.gmail.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	 <20111020125705.GA2121@earth.universe>
	 <CACRpkdYBFGp4+oFUZvXn-wpUk0fmLiKixchQKcFo9XTDW=51+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Oct 2011 13:28:33 +0300
Message-ID: <1319192913.2702.38.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-21 at 11:54 +0200, ext Linus Walleij wrote:
> On Thu, Oct 20, 2011 at 2:57 PM, Sebastian Reichel <sre@debian.org> wrote:
> 
> > What's the status of this patch? Are there plans to merge it into
> > 3.2?
> 
> If there were, it'd be part of linux-next by now wouldn't it?
> 
> Carlos, can you tell us what's happening, this is starting to
> look pretty solid and it sort of hurts to have it out-of-tree.
> 

Yes I agree. I want to have the omap_ssi controller driver ready for
acceptance for linux-omap. It is currently the only thing blocking the
last patch set. Unfortunately, I am behind on that but I am still
committed to deliver the changes for it.

> Can't you create a for-next branch and ask Stephen to pull
> that to linux-next so it can be merged for linux 3.3?
> 

Yes I can, but currently not with the changes needed in the omap_ssi
controller driver. Basically, we have 2 alternatives for that:

A. I create the branch with just the hsi_char and the hsi framework
B. The same as A but with STE or another hsi/ssi controller driver.

Any more ideas ? preferences ?

Br,
Carlos

