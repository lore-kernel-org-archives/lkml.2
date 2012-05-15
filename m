Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966637Ab2EOT6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:58:23 -0400
Received: from londo.lunn.ch ([80.238.139.98]:38466 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427Ab2EOT6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:58:22 -0400
Date: Tue, 15 May 2012 21:58:01 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH RFC] spi: Dont call prepare/unprepare transfer if not
 populated
Message-ID: <20120515195801.GE23254@lunn.ch>
References: <1336657841-2306-1-git-send-email-shubhrajyoti@ti.com>
 <CACRpkdZmr+i6d+k8XU6Qxo425=mFZo5kzUe1wFk+grxDshaoVA@mail.gmail.com>
 <20120511032455.6BB853E04A6@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511032455.6BB853E04A6@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 09:24:55PM -0600, Grant Likely wrote:
> On Thu, 10 May 2012 16:01:27 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Thu, May 10, 2012 at 3:50 PM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> > 
> > > Currently the prepare/unprepare transfer are called unconditionally.
> > > The assumption is that every driver using the spi core queue infrastructure
> > > has to populate the prepare and unprepare functions. This encourages
> > > drivers to populate empty functions to prevent crashing.
> > > This patch prevents the call to prepare/unprepare if not populated.
> > >
> > > Cc: Linus Walleij <linus.walleij@linaro.org>
> > > Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> > 
> > Great!
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Applied, thanks (after fixing extra whitespace defect).

Hi Grant

Is this going to appear in linux-next soon? Can i depend on having
this patch for 3.5?

     Thanks
	Andrew

