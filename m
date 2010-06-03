Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873Ab0FCKcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:32:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65129 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933843Ab0FCKcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UK78qZLDD56jAQ3iQ5m34k1myf7AMjAqm5RIQmEvQM2VnnkVtV5ZB4irvKm5ZHKiHK
         dF8GR6SnTEiUAvzPIwz/Y4tj2OKkwboQ7Ke8+Z0Wr+gk/lGlmWSNuFQ75rZIetzqH78G
         O1dQb7G9W6FkR4CBSeKx/HDMxP9WjxGcZZwi0=
MIME-Version: 1.0
In-Reply-To: <87ljaw1obm.fsf@erwin.mina86.com>
References: <cover.1275481997.git.mina86@mina86.com>
	<5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
	<e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
	<785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
	<5492eaf531c8a59c7c188b9e341572c9cdaed5f2.1275481997.git.mina86@mina86.com>
	<17b54e2cc00a7f730483401f06c79c781491dc62.1275481997.git.mina86@mina86.com>
	<381c3f8318e39caaffa1ecfdf5e3cf13ed59cd27.1275481997.git.mina86@mina86.com>
	<c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
	<AANLkTikAhJXiKGzyK7j3V7ev_6f2mn8f-A9tDmgdHy9I@mail.gmail.com>
	<op.vdojfktu7p4s8u@pikus>
	<AANLkTinwDV9Egrfy_ml998vWIKWs5AasrJMrgxIWOrCo@mail.gmail.com>
	<AANLkTikKgpm5j453ApJoMeskZdac8iXTBODzb-lCpMT1@mail.gmail.com>
	<87ljaw1obm.fsf@erwin.mina86.com>
Date: Thu, 3 Jun 2010 18:32:09 +0800
Message-ID: <AANLkTilxtSiDG0PptXHiaeN6gcRPYPX70xHCSRPljbxA@mail.gmail.com>
Subject: Re: [PATCHv3 07/11] USB: gadget: g_multi: added documentation and INF 
	files
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
       linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 5:02 PM, Michal Nazarewicz <mina86@mina86.com> wrote:
>> So if your employer (Samsung) or others is quite nice and submit the
>> driver package (the inf and cat file for CDC-ACM) for WHQL and got
>> approved, in the future, users of the inf file will not see the red color
>> warning. This might be desired for corporate customers.
>
> I *personally* see how it may be a problem for _any_ corporation since
> singing is like saying "yes, we guarantee it won't destroy your computer
> nor it will summon demons" and by releasing signed driver you in effect
> loose control over it.  Again, further signature investigations are on
> my TODO list.
>

As I mentioned before, WHQL submission is not necessary for
drivers using usbser.sys. It will work under 32bit/64bit Windows.
The warning just scares some innocent customers.

You do not need the catalog file here. Those vendors who likes to get
the WHQL can pay the money to get it (for their particular VID/PID).

For drivers like libusb-win32 (libusb0.sys), it is a big problem since
you can not load it under 64bit Vista/Win7. libusb-win32 is quite
nice project to port Linux libusb based application to Windows.
So we in the libusb-win32 project plan to get the money through
donation to buy the digital certificate so that it can work under
64bit Vista/Win7 and users can load it (with the red warning
since the driver package are not signed with the digital
certificate, inf file is part of the driver package). Corporate
users of libusb-win32 (eg: Atmel) can choose to go for WHQL so that
their users will not see the red warning.
(ref: http://sourceforge.net/news/?group_id=78138 )

usbser.sys is already signed by Microsoft, so you will not
face such issue. Same thing for the drivers of USB RNDIS.

-- 
Xiaofan http://mcuee.blogspot.com
