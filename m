Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab0LBR5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 12:57:17 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:59161 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757966Ab0LBR5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 12:57:14 -0500
X-Greylist: delayed 1235 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Dec 2010 12:57:12 EST
From: Matteo DAMENO <matteo.dameno@st.com>
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: mems applications <mems.applications@st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Carmine IASCONE <carmine.iascone@st.com>, Greg KH <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>
Date: Thu, 2 Dec 2010 18:35:59 +0100
Subject: RE: [PATCH] input: misc: add lps001wp_prs driver
Thread-Topic: [PATCH] input: misc: add lps001wp_prs driver
Thread-Index: AcuQektbgEEa7KuzRNW5XQnNsTuPBgByNP8A
Message-ID: <9BF90A6D61BF154E973D03082989295CA22B3F7E95@SAFEX1MAIL3.st.com>
References: <matteo.dameno@st.com>
 <1291049009-32597-1-git-send-email-matteo.dameno@st.com>
 <20101130060926.GA31838@core.coreip.homeip.net>
 <AANLkTikpVtq2cQVhhcsJhZwGFW74mTqo=-vVK1e50AC2@mail.gmail.com>
In-Reply-To: <AANLkTikpVtq2cQVhhcsJhZwGFW74mTqo=-vVK1e50AC2@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oB2Hvc3C027716



> -----Original Message-----
> From: Mohamed Ikbel Boulabiar [mailto:boulabiar@gmail.com]
> Sent: Tuesday, November 30, 2010 11:35 AM
> To: Dmitry Torokhov
> Cc: mems applications; linux-input@vger.kernel.org; linux-
> kernel@vger.kernel.org; Matteo DAMENO; Carmine IASCONE; mems
> Subject: Re: [PATCH] input: misc: add lps001wp_prs driver
> 
> On Tue, Nov 30, 2010 at 7:09 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >> + Â  Â  Â If you say yes here you get support for the
> >> + Â  Â  Â STM LPS001D Barometer/Termometer on I2C bus.
> >
> > This does not belong to input subsystem, IIO is a better fit.
> 
> According to this site:
> http://www.cnbc.com/id/40413317
> and its datasheet:
> http://www.findmems.com/wp-content/uploads/2010/11/LPS001WP-
> DATASHEET.pdf
> 
> This sensors applications are:
> â–  Altimeter and barometer for portable devices
> â–  Smartphones
> â–  Indoor navigation
> â–  GPS applications
> â–  Weather station equipment
> â–  Sports watches
> 
> "the same devices would be able to identify the precise location in
> all three dimensions, allowing, for example, a mobile phone to send a
> call to an emergency fire, medical or police service that identified
> not only the location of the building but also the particular floor."
> Identifying 3d location is similar to what many joystick are doing.
> 
> Specially the indoor navigation information means an information about
> the user. And the information is very tied to the user.
> I don't know whether this can be used to map with virtual reality in a
> game, or where you use sensors data to give user informations when
> visiting a museum.
> 
> 
> Dmitry, is it possible to start putting similar drivers in a new
> drivers/input/sensors directory but which belongs to the input
> subsystem ? What do you think ?
> 

We agree with you.
It would be a good idea.
We are working on many device drivers that are matching your description and
we are ready to submit them.

We are disoriented because every maintainer seems to bounce our submissions
because of inappropriate position for the device.

IIO, input/misc, I2C (we didn't submit here because of deprecation stated in
Documentation). Some one is also submitting our drivers with modifications 
under Hwmon...

What to do?

Matteo Dameno

> 
> i
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
