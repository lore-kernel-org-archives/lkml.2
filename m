Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2JGQVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:21:12 -0400
Received: from smtp.intuilab.com ([93.93.42.171]:38046 "EHLO
	zimbra.intuilab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2JGQVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:21:03 -0400
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification  implementation
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <CAN+gG=FOnFDn4BdEQUt0dbQRj-6PrhRzSOqM620xSM3DeTXt_Q@mail.gmail.com>
Date: Sun, 7 Oct 2012 18:20:54 +0200
Cc: Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?iso-8859-1?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        =?utf-8?B?5YqJ5ZiJ6ae/?= <scott.liu@emc.com.tw>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, USB list <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <91E2364F-9A56-4222-A876-BEC6D474EC75@enac.fr>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>< 20121006220421.47f5fd56@endymion.delvare><6F756B9E-DC87-4EF6-BB09-8A69A5F8C 999@enac.fr><20121006231111.6350c014@endymion.delvare><alpine.LNX.2.00.1210 062314110.27782@pobox.suse.cz><alpine.LNX.2.00.1210062326150.27782@pobox.su se.cz><914C6C58-5A3B-4F7D-94BE-EF6868ED5D9D@enac.fr> <CAN+gG=FOnFDn4BdEQUt0dbQRj-6PrhRzSOqM620xSM3DeTXt_Q@mail.gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 7 oct. 2012 à 18:07, Benjamin Tissoires a écrit :
>>> 
>>> Basically, to me this all boils down to the question -- what is more
>>> important: low-level transport being used, or the general function of the
>>> device?
>>> 
>>> To me, it's the latter, and as such, everything would belong under
>>> drivers/hid.
>> 
>> Then shouldn't is be drivers/input, rather?
> 
> Ouch, it will introduce more and more complexity.

Purely rhetorical question, I agree. But still.

> 
> It seems that hid transport layers should go in drivers/hid.
> However, I don't like mixing the transport layer and the final
> drivers. Maybe this is the time to rework a little bit the tree.
> To minimize the moves, we could introduce:
> drivers/hid/busses/usb
> drivers/hid/busses/i2c
> drivers/hid/busses/bluetooth

What about creating drivers/hid/core and move all generic stuff there? That is:
drivers/hid/core
drivers/hid/usb
drivers/hid/i2c
drivers/hid/bluetooth

Cheers,

St.


