Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0GVPng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:43:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39055 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab0GVPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=VwGlywn7HB/8FVLe2yfIMaU+6FOq0vcX5l6a0NfG7nkpykZ3g6fAr46tLyKw8Lxhxe
         We5uOGGG3qNwshPmCAhLPjrpWoR7ml+Y9lfsFbG2PdKtnyCOoWtZP8hQvV01ttKTh5nq
         i/GD4wyWnYj2oyvHBm0AD4AyyaGMiw0wOtw/M=
Date: Thu, 22 Jul 2010 08:43:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] keypad/nuc900: change keypad driver name from
 'nuc900-keypad' to 'nuc900-kpi'
Message-ID: <20100722154328.GA21971@core.coreip.homeip.net>
References: <4C431211.6030706@gmail.com>
 <AANLkTil5hsZYCWaMekzPkLfEC0_wxmBWfT3jj0IC5j6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil5hsZYCWaMekzPkLfEC0_wxmBWfT3jj0IC5j6f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wan,

On Thu, Jul 22, 2010 at 01:34:17PM +0800, Wan ZongShun wrote:
> Dmitry,
> 
> Can it be applied?
> 

It is applied to my 'for-linus' branch.

Thanks.

> Thanks!
> 
> > Hi Dmitry,
> >
> > I ever changed the keypad platform device name from 'nuc900-keypad' to
> > 'nuc900-kpi', but I forget to modify the related keypad driver name,so
> > the keypad driver does not work,I have to send the patch to fix this issue.
> >
> > Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
> > ---
> >  drivers/input/keyboard/w90p910_keypad.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/input/keyboard/w90p910_keypad.c b/drivers/input/keyboard/w90p910_keypad.c
> > index 4ef764c..ee2bf6b 100644
> > --- a/drivers/input/keyboard/w90p910_keypad.c
> > +++ b/drivers/input/keyboard/w90p910_keypad.c
> > @@ -258,7 +258,7 @@ static struct platform_driver w90p910_keypad_driver = {
> >        .probe          = w90p910_keypad_probe,
> >        .remove         = __devexit_p(w90p910_keypad_remove),
> >        .driver         = {
> > -               .name   = "nuc900-keypad",
> > +               .name   = "nuc900-kpi",
> >                .owner  = THIS_MODULE,
> >        },
> >  };
> > --
> > 1.6.3.3
> >
> 
> 
-- 
Dmitry
