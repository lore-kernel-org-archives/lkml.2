Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888Ab0GAWmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:42:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39909 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab0GAWml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=eIdz1xmFrP07yQNqzu9eHERttwqEmvy1bx3MQJ6ylrerfO/8c55bhQC5THEvjr6ZlL
         +iwOrs7nn9bYFIGRH7c/4bXoiC80NR5WzpIT6JYnjAb0leRqLe5EXEQ9Q66n2aE57f+2
         lpoC5uxrqd5kzX+EhAUhEp8E4+Y7mDLhvHe/I=
Date: Thu, 1 Jul 2010 15:42:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jerome Lacoste <jerome.lacoste@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active
 multiplexor, mouse won't work.)
Message-ID: <20100701224235.GA29504@core.coreip.homeip.net>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
 <20100701162454.GD4152@core.coreip.homeip.net>
 <AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
 <AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 12:28:17AM +0200, Jerome Lacoste wrote:
> On Thu, Jul 1, 2010 at 11:19 PM, Jerome Lacoste
> <jerome.lacoste@gmail.com> wrote:
> > On Thu, Jul 1, 2010 at 6:24 PM, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> >> Hi Jerome,
> >>
> > [...]
> >>> * the hardware is a Lenovo 3000 N100
> >>
> >> We already trying to disable MUX mode on Lenovo 3000 N100, see
> >> drivers/input/serio/i8042-x86ia64io.h:
> >>
> >>        {
> >>                /* Lenovo 3000 n100 */
> >>                .matches = {
> >>                        DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> >>                        DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
> >>                },
> >>        },
> >>
> >> What's in your dmi?
> >
> > System Information
> >        Manufacturer: LENOVO
> >        Product Name: 0768BKG
> >        Version: 3000 N100
> >
> > according to dmidecode
> 
> Note: I will try the i8042.nomux option, but can't reboot until tomorrow.

Could you please also try i8042.reset instead of i8042.nomux?

-- 
Dmitry
