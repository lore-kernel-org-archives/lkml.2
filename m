Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab2FZB2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 21:28:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50250 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab2FZB2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 21:28:01 -0400
Date: Mon, 25 Jun 2012 18:27:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/22 v4] Input: atmel_mxt_ts - set phys to i2c client
 adapter name
Message-ID: <20120626012751.GB24705@core.coreip.homeip.net>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
 <1339992522-22073-2-git-send-email-djkurtz@chromium.org>
 <20120621084107.GB2193@core.coreip.homeip.net>
 <20120625081558.GA641@polaris.bitmath.org>
 <CAGS+omD5xp1PeXGMdsz6uP-QL2rU+sfoPBmOPGqi2p8NE9S4Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omD5xp1PeXGMdsz6uP-QL2rU+sfoPBmOPGqi2p8NE9S4Jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 05:58:46PM +0800, Daniel Kurtz wrote:
> On Mon, Jun 25, 2012 at 4:15 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> >
> > On Thu, Jun 21, 2012 at 01:41:07AM -0700, Dmitry Torokhov wrote:
> > > On Mon, Jun 18, 2012 at 12:08:21PM +0800, Daniel Kurtz wrote:
> > > > This allows userspace to more easily distinguish which bus a
> > > > particular
> > > > atmel_mxt_ts device is attached to.
> > > >
> > > > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > > > ---
> > > >  drivers/input/touchscreen/atmel_mxt_ts.c |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c
> > > > b/drivers/input/touchscreen/atmel_mxt_ts.c
> > > > index 42e6450..eda9eed 100644
> > > > --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> > > > +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> > > > @@ -1106,6 +1106,7 @@ static int __devinit mxt_probe(struct i2c_client
> > > > *client,
> > > >     }
> > > >
> > > >     input_dev->name = "Atmel maXTouch Touchscreen";
> > > > +   input_dev->phys = client->adapter->name;
> > >
> > > Normally we set phys to 'xxx/input0' nstead of just the adaptor name.
> >
> > Daniel, will we be seeing another version of this patch?
> 
> Yes.  Any guidance on "xxx" ?  atmel_mxt_ts?

What you have before (client->adapter->name) + "/input0" shoudl work
splendidly.

Thanks.

-- 
Dmitry
