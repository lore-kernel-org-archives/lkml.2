Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2LEAaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 19:30:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15924 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2LEAaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 19:30:01 -0500
X-AuditID: cbfee61b-b7f616d00000319b-08-50be95873cb8
From: Jingoo Han <jg1.han@samsung.com>
To: "=?iso-8859-2?Q?'Marko_Kati=E6'?=" <dromede@gmail.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        linux-arm-kernel@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000b01cdd1e0$293f0d90$7bbd28b0$%han@samsung.com>
 <CAHod+Gf6TSAS7+543prWb8To8UGevYFMZnZoN7weWu36Mws8ow@mail.gmail.com>
In-reply-to: <CAHod+Gf6TSAS7+543prWb8To8UGevYFMZnZoN7weWu36Mws8ow@mail.gmail.com>
Subject: Re: [PATCH v3] backlight: corgi_lcd: Use gpio_set_value_cansleep() to
 avoid WARN_ON
Date: Wed, 05 Dec 2012 09:29:59 +0900
Message-id: <000001cdd27f$a88f1000$f9ad3000$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3Sdv+cQ8/AvJ4ZQByJc6iX/QrB7AACDNvA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zQ932qfsCDO6tkbG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZu6+2MBfs16pY9GMnYwPjIaUuRk4OCQETifsb/rFC2GISF+6t
	Z+ti5OIQEljGKLF22idGmKKmc3dYIRKLGCXW7XzCAuHMZpLoPHyQDaSKTUBN4suXw+xdjBwc
	IgIWEs/npoCEmQW2MEksPmgDUd/CKPF0dw/YOk6BYIk3C5pZQGxhgTiJ/3P7mEBsFgFViW2H
	H7CD2LwCthKTmvYxQ9iCEj8m32MBmc8soCPxdVIExHx5ic1r3jKDhCUE1CUe/dWFuMBIYlqf
	JkSFiMS+F+8YIYYLSHybfIgFolpWYtMBZpDDJASWsUvcW93JDvGupMTBFTdYJjBKzEKydxbC
	3llI9s5CsmEBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjJCokt7BuKrB4hCjAAejEg+v
	hPG+ACHWxLLiytxDjBIczEoivP/sgEK8KYmVValF+fFFpTmpxYcYfYAOn8gsJZqcD4z4vJJ4
	Q2NjEzMTUxNzS1NzUxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYxQwYt22f6cb+fsqL
	MzLVD/lOW86LqlZ9rxjyXEVk9ycW1ji5mpg1wtMZP5+cvuyBfFNA7IQj8i5ZL/wmLr7fcP/m
	rLLsVRJsNRfP76oz1DfaLvhh8bd8WfMPcYw63O4RKwIcpxyRLv1Zs2n9YqNnyToOJVWmAQmP
	GOd9+G15LGfK+dc5rMn+SizFGYmGWsxFxYkAfcRojdcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAd32qfsCDJZsFrO4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGbuvtjAX7NeqWPRjJ2MD
	4yGlLkZODgkBE4mmc3dYIWwxiQv31rN1MXJxCAksYpRYt/MJC4Qzm0mi8/BBNpAqNgE1iS9f
	DrN3MXJwiAhYSDyfmwISZhbYwiSx+KANRH0Lo8TT3T1gUzkFgiXeLGhmAbGFBeIk/s/tYwKx
	WQRUJbYdfsAOYvMK2EpMatrHDGELSvyYfI8FZD6zgI7E10kREPPlJTavecsMEpYQUJd49FcX
	4gIjiWl9mhAVIhL7XrxjnMAoNAvJnFkIc2YhmTMLSccCRpZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMEx+0x6B+OqBotDjAIcjEo8vBLG+wKEWBPLiitzDzFKcDArifD+swMK8aYkVlal
	FuXHF5XmpBYfYvQB+nIis5Rocj4wneSVxBsam5gZWRqZWRiZmJvjEFYS5232SAkQEkhPLEnN
	Tk0tSC2CGcfEwSnVwCipu0ZFKmsuq4BhZFqJbtUT9y3zWhMso/9dyL5nV/k5XFLp/mqZGZP/
	N195tPj9udYzFW+bgxZbyLd7nNltdDKq8Y5Q41Pdi4/3NSzjehlk4OR0TYjt4byqA/sqJlcu
	WPlkn/O1ifsS32z4x1wpe/Ji7KTLPglSIvPFo/v5a+RLFuV53Y3j4lZiKc5INNRiLipOBADT
	jWNtBgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 05, 2012 8:28 AM, Marko Katic wrote
> On Tue, Dec 4, 2012 at 6:28 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > From: Marko Katic <dromede@gmail.com>
> >
> > Changing backlight intensity on an Akita (Sharp Zaurus C-1000)
> > triggers WARN_ON message:
> >
> > WARNING: at drivers/gpio/gpiolib.c:1672 __gpio_set_value+0x38/0xa4()
> > Modules linked in:
> > Backtrace:
> > [<c000c0ac>] (dump_backtrace+0x0/0x110) from [<c02c8278>] (dump_stack+0x18/0x1c)
> >  r6:c0158fc8 r5:00000009 r4:00000000 r3:c03d4f70
> > [<c02c8260>] (dump_stack+0x0/0x1c) from [<c0019194>] (warn_slowpath_common+0x54/0x6c)
> > [<c0019140>] (warn_slowpath_common+0x0/0x6c) from [<c00191d0>] (warn_slowpath_null+0x24/0x2c)
> >  r8:c38d5c00 r7:c03f82c0 r6:00000000 r5:000000d0 r4:c384e4fc
> > r3:00000009
> > [<c00191ac>] (warn_slowpath_null+0x0/0x2c) from [<c0158fc8>] (__gpio_set_value+0x38/0xa4)
> > [<c0158f90>] (__gpio_set_value+0x0/0xa4) from [<c0169b4c>] (corgi_bl_set_intensity+0x44/0x74)
> >  r7:c3933418 r6:c3933400 r5:c392cdf0 r4:0000002f
> > [<c0169b08>] (corgi_bl_set_intensity+0x0/0x74) from [<c0169c1c>] (corgi_bl_update_status+0x5c/0x64)
> >  r5:c03d31f0 r4:c3933400
> > [<c0169bc0>] (corgi_bl_update_status+0x0/0x64) from [<c02c3a68>] (corgi_lcd_probe+0x1a8/0x258)
> >  r4:c392cdf0 r3:c0169bc0
> > [<c02c38c0>] (corgi_lcd_probe+0x0/0x258) from [<c01da7a4>] (spi_drv_probe+0x20/0x24)
> >  r8:00000052 r7:c0192d9c r6:c03da6e8 r5:c38d5c34 r4:c38d5c00
> > [<c01da784>] (spi_drv_probe+0x0/0x24) from [<c0192c44>] (driver_probe_device+0xb0/0x208)
> > [<c0192b94>] (driver_probe_device+0x0/0x208) from [<c0192e0c>] (__driver_attach+0x70/0x94)
> >  r6:c03da6e8 r5:c38d5c34 r4:c38d5c00 r3:00000000
> > [<c0192d9c>] (__driver_attach+0x0/0x94) from [<c0191268>] (bus_for_each_dev+0x54/0x90)
> >  r6:c03da6e8 r5:c3827e80 r4:00000000 r3:00000000
> > [<c0191214>] (bus_for_each_dev+0x0/0x90) from [<c01927a4>] (driver_attach+0x20/0x28)
> >  r7:00000000 r6:c03e29ec r5:c3932980 r4:c03da6e8
> > [<c0192784>] (driver_attach+0x0/0x28) from [<c0192340>] (bus_add_driver+0xd4/0x22c)
> > [<c019226c>] (bus_add_driver+0x0/0x22c) from [<c019335c>] (driver_register+0xa4/0x134)
> >  r8:00000052 r7:c03ea900 r6:c03c32ac r5:c03bdfc8 r4:c03da6e8
> > [<c01932b8>] (driver_register+0x0/0x134) from [<c01db7ec>] (spi_register_driver+0x4c/0x60)
> > [<c01db7a0>] (spi_register_driver+0x0/0x60) from [<c03b3ce0>] (corgi_lcd_driver_init+0x14/0x1c)
> > [<c03b3ccc>] (corgi_lcd_driver_init+0x0/0x1c) from [<c000868c>] (do_one_initcall+0x9c/0x174)
> > [<c00085f0>] (do_one_initcall+0x0/0x174) from [<c02c1b94>] (kernel_init+0xf4/0x2a8)
> > [<c02c1aa0>] (kernel_init+0x0/0x2a8) from [<c0009270>] (ret_from_fork+0x14/0x24)
> > ---[ end trace a863a63f242ee38c ]---
> >
> > Akita machines have backlight controls hooked to a gpio expander chip,
> > max7310. In this case, pca953x_gpio_set_value() can be called to control
> > gpio, and pca953x_setup_gpio() sets can_sleep flag. Therefore,
> > gpio_set_value_cansleep() should be used in order to avoid WARN_ON on
> > akita machines.
> >
> > Akita is the only exception in this case since other users of corgi_lcd
> > access backlight gpio controls through a different gpio expander such as
> > max7310 which does not set the can_sleep flag.
> 
> I think you forgot to delete "such as max7310". Akita has
> the max7310, all the other models have a different expander.

Yes, you're right.
I added an unnecessary word, 'such as max7310'.
It should be deleted.

I will send v4 patch, soon.

Best regards,
Jingoo Han

> 
> >
> > [jg1.han@samsung.com: used gpio_cansleep()]
> > Signed-off-by: Marko Katic <dromede@gmail.com>
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/video/backlight/corgi_lcd.c |   17 +++++++++++++----
> >  1 files changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
> > index e2e1b62..e5168f4 100644
> > --- a/drivers/video/backlight/corgi_lcd.c
> > +++ b/drivers/video/backlight/corgi_lcd.c
> > @@ -408,11 +408,20 @@ static int corgi_bl_set_intensity(struct corgi_lcd *lcd, int intensity)
> >         /* Bit 5 via GPIO_BACKLIGHT_CONT */
> >         cont = !!(intensity & 0x20) ^ lcd->gpio_backlight_cont_inverted;
> >
> > -       if (gpio_is_valid(lcd->gpio_backlight_cont))
> > -               gpio_set_value(lcd->gpio_backlight_cont, cont);
> > +       if (gpio_is_valid(lcd->gpio_backlight_cont)) {
> > +               if (gpio_cansleep(lcd->gpio_backlight_cont))
> > +                       gpio_set_value_cansleep(lcd->gpio_backlight_cont, cont);
> > +               else
> > +                       gpio_set_value(lcd->gpio_backlight_cont, cont);
> > +       }
> >
> > -       if (gpio_is_valid(lcd->gpio_backlight_on))
> > -               gpio_set_value(lcd->gpio_backlight_on, intensity);
> > +       if (gpio_is_valid(lcd->gpio_backlight_on)) {
> > +               if (gpio_cansleep(lcd->gpio_backlight_on))
> > +                       gpio_set_value_cansleep(lcd->gpio_backlight_on,
> > +                                               intensity);
> > +               else
> > +                       gpio_set_value(lcd->gpio_backlight_on, intensity);
> > +       }
> >
> >         if (lcd->kick_battery)
> >                 lcd->kick_battery();
> > --
> > 1.7.2.5
> >
> >

