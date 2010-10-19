Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0JSSPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:15:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37505 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0JSSPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:15:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kNli3xaTGq2sNMwm8DBlwTYIuupCvJ+xKNrHKYf/AEKKcuRyRYgGghlWYAf6k4Mt9R
         k1Wruj1b7BL8Ua7HsTYTnhWUEGcul2y4AnpMbKPjeDHR7/H0qMy/SPr8gibOdGHQzcUU
         6arRYn6OiGVBT3qqYmaWzU5uBxdCZKiUYOenw=
MIME-Version: 1.0
In-Reply-To: <20101019175036.GB4618@kroah.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-3-git-send-email-felipe.contreras@gmail.com>
	<20101019155109.GH4589@kroah.com>
	<AANLkTi=CzBriAFW2gzG68b=6wENysJZEkaO9jFrXQdnq@mail.gmail.com>
	<20101019175036.GB4618@kroah.com>
Date: Tue, 19 Oct 2010 21:15:21 +0300
Message-ID: <AANLkTinRCaXO1nO3sZdbiAHont+vgd4eZE9EN-snjZYg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] usb: trivial Kconfig cleanups
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 8:50 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Oct 19, 2010 at 08:15:19PM +0300, Felipe Contreras wrote:
>> On Tue, Oct 19, 2010 at 6:51 PM, Greg KH <greg@kroah.com> wrote:
>> > On Tue, Oct 19, 2010 at 01:03:27PM +0300, Felipe Contreras wrote:
>> >> Note: USB_GADGET_MUSB_HDRC is already defined in usb/gadget.
>> >>
>> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> >
>> > Please describe _what_ trivial cleanups you did, and why you did them.
>> > Care to resend?
>>
>> How about:
>> Shuffle the code a bit so the description is at the top, remove
>> duplicated configs (USB_GADGET_MUSB_HDRC),  'default n' is redundant,
>> and USB_GADGET_SELECTED should go after USB_GADGET (on the appropriate
>> config).
>
> Sounds good, but you need to resend it with this information in it, not
> much I can do with it in an independant email.

I know that, I just wanted to see if it was ok before resending so I
don't resend another time.

-- 
Felipe Contreras
