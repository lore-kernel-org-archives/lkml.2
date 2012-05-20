Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab2ETFAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 01:00:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47310 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2ETFAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 01:00:35 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC] spi: Dont call prepare/unprepare transfer if not populated
To: Andrew Lunn <andrew@lunn.ch>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        andrew@lunn.ch
In-Reply-To: <20120515195801.GE23254@lunn.ch>
References: <1336657841-2306-1-git-send-email-shubhrajyoti@ti.com> <CACRpkdZmr+i6d+k8XU6Qxo425=mFZo5kzUe1wFk+grxDshaoVA@mail.gmail.com> <20120511032455.6BB853E04A6@localhost> <20120515195801.GE23254@lunn.ch>
Date: Sat, 19 May 2012 23:00:33 -0600
Message-Id: <20120520050033.1D3DD3E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 21:58:01 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, May 10, 2012 at 09:24:55PM -0600, Grant Likely wrote:
> > On Thu, 10 May 2012 16:01:27 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> > > On Thu, May 10, 2012 at 3:50 PM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> > > 
> > > > Currently the prepare/unprepare transfer are called unconditionally.
> > > > The assumption is that every driver using the spi core queue infrastructure
> > > > has to populate the prepare and unprepare functions. This encourages
> > > > drivers to populate empty functions to prevent crashing.
> > > > This patch prevents the call to prepare/unprepare if not populated.
> > > >
> > > > Cc: Linus Walleij <linus.walleij@linaro.org>
> > > > Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> > > 
> > > Great!
> > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > 
> > Applied, thanks (after fixing extra whitespace defect).
> 
> Hi Grant
> 
> Is this going to appear in linux-next soon? Can i depend on having
> this patch for 3.5?

It's pushed out now.

g.

