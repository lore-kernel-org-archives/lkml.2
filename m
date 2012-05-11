Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab2EKD2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:28:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44234 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab2EKD2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:28:48 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC] spi: Dont call prepare/unprepare transfer if not populated
To: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        andrew@lunn.ch
In-Reply-To: <CACRpkdZmr+i6d+k8XU6Qxo425=mFZo5kzUe1wFk+grxDshaoVA@mail.gmail.com>
References: <1336657841-2306-1-git-send-email-shubhrajyoti@ti.com> <CACRpkdZmr+i6d+k8XU6Qxo425=mFZo5kzUe1wFk+grxDshaoVA@mail.gmail.com>
Date: Thu, 10 May 2012 21:24:55 -0600
Message-Id: <20120511032455.6BB853E04A6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 16:01:27 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, May 10, 2012 at 3:50 PM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> 
> > Currently the prepare/unprepare transfer are called unconditionally.
> > The assumption is that every driver using the spi core queue infrastructure
> > has to populate the prepare and unprepare functions. This encourages
> > drivers to populate empty functions to prevent crashing.
> > This patch prevents the call to prepare/unprepare if not populated.
> >
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> 
> Great!
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks (after fixing extra whitespace defect).

g.

