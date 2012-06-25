Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab2FYJ7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:59:11 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55223 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2FYJ7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120625081558.GA641@polaris.bitmath.org>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
 <1339992522-22073-2-git-send-email-djkurtz@chromium.org> <20120621084107.GB2193@core.coreip.homeip.net>
 <20120625081558.GA641@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 25 Jun 2012 17:58:46 +0800
X-Google-Sender-Auth: BQWbAhFqa13GtPhXOSSS-qP3dt0
Message-ID: <CAGS+omD5xp1PeXGMdsz6uP-QL2rU+sfoPBmOPGqi2p8NE9S4Jw@mail.gmail.com>
Subject: Re: [PATCH 01/22 v4] Input: atmel_mxt_ts - set phys to i2c client
 adapter name
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 4:15 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>
> On Thu, Jun 21, 2012 at 01:41:07AM -0700, Dmitry Torokhov wrote:
> > On Mon, Jun 18, 2012 at 12:08:21PM +0800, Daniel Kurtz wrote:
> > > This allows userspace to more easily distinguish which bus a
> > > particular
> > > atmel_mxt_ts device is attached to.
> > >
> > > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > > ---
> > >  drivers/input/touchscreen/atmel_mxt_ts.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c
> > > b/drivers/input/touchscreen/atmel_mxt_ts.c
> > > index 42e6450..eda9eed 100644
> > > --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> > > +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> > > @@ -1106,6 +1106,7 @@ static int __devinit mxt_probe(struct i2c_client
> > > *client,
> > >     }
> > >
> > >     input_dev->name = "Atmel maXTouch Touchscreen";
> > > +   input_dev->phys = client->adapter->name;
> >
> > Normally we set phys to 'xxx/input0' nstead of just the adaptor name.
>
> Daniel, will we be seeing another version of this patch?

Yes.  Any guidance on "xxx" ?  atmel_mxt_ts?
What if there are two devices using the same driver?

>
> Thanks,
> Henrik
