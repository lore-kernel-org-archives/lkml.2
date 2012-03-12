Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2CLRnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:43:00 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37824 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2CLRm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:42:58 -0400
Message-ID: <1331574151.14217.86.camel@aeonflux>
Subject: Re: [PATCH 4/5] HID: autoload hid-multitouch as needed
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: =?ISO-8859-1?Q?St=E9phane?= Chatty <chatty@enac.fr>,
        Henrik Rydberg <rydberg@euromail.se>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org
Date: Mon, 12 Mar 2012 10:42:31 -0700
In-Reply-To: <alpine.LNX.2.00.1203121650500.18356@pobox.suse.cz>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
	 <1331053026-21272-5-git-send-email-benjamin.tissoires@gmail.com>
	  <alpine.LNX.2.00.1203072234550.29034@pobox.suse.cz>
	 <20120308105737.GA11201@polaris.bitmath.org>
	 <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr>
	 <alpine.LNX.2.00.1203121650500.18356@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > > What if we were to change the definition of a HID device on the
> > > modalias level?
> > > 
> > > In practise, a HID device can be either an usb device, a hid device,
> > 
> > Just to be sure: do you mean "bluetooth device"? or is there such a 
> > thing as a hid device per se? I'm asking because I've always been 
> > surprised at seeing usbhid/ in hid/, which kind of breaks the potential 
> > symmetry between USB and Bluetooth wrt hid.
> 
> Please don't get confused by the directory layout ... this has mostly 
> non-technical reasons -- Marcel wanted to keep bluetooth/hidp under his 
> wings, and I didn't have reasons to object strongly.
> 
> I am adding Marcel and Gustavo to CC just in case they have changed their 
> mind, but it's definitely a side-topic in this discussion.

I have not changed my mind. HIDP is Bluetooth specific and should stay
there. Especially since we are currently discussing changes to make
things also work over Bluetooth Low Energy (LE), but that is a complete
different topic and it just started.

> Marcel, Gustavo -- if you are interested in the whole discussion regarding 
> potential extension of HID core infrastructure to better suit multitouch, 
> please see the whole thread at http://marc.info/?t=133105322800006&r=1&w=4

HIDP is just a transport driver in the end. And I heard that the Apple
Magic Trackpad actually does work nicely. Never tried it by myself.

Regards

Marcel


