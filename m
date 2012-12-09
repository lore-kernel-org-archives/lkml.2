Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab2LIJ62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 04:58:28 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57722 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab2LIJ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 04:58:27 -0500
Subject: Re: [PATCH] gpio: export 'debounce' attribute if supported by the
 gpio chip
From: anish kumar <anish198519851985@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Guenter Roeck <groeck-dsl@sbcglobal.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <20121207164906.08b65046@pyramind.ukuu.org.uk>
References: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
	 <CACRpkdYDLJDwv97Z0agZBbzCtEdeb5Y-83K2HkZRtLP1Cz_QiA@mail.gmail.com>
	 <20121207145955.GA28704@roeck-us.net>
	 <20121207164906.08b65046@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Dec 2012 01:58:19 -0800
Message-ID: <1355047099.1673.5.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 16:49 +0000, Alan Cox wrote:
> > I could imagine declaring the activity request buttons to be "input", but for
> > presence detects it is a bit far fetched and would add too much complexity.
> 
> Android tries to address this with its switch class driver, but I'm not
> sure its actually got anything over making them input devices.

Sorry for not understanding the context here.How the debounce sysfs
added by Guenter has anything to do with switch driver in android?

AFAIK android just uses switch driver api to talk to driver to get the
status of the headset and the status of the keys if headset has any.This
API in turn updates the sysfs to let userspace know the status change
using kobject uevent.
 
Switch driver is replaced by extcon in the mainline.
> 
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


