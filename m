Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2JFVjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 17:39:13 -0400
Received: from smtp.intuilab.com ([93.93.42.171]:60048 "EHLO
	zimbra.intuilab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2JFVjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 17:39:11 -0400
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification   implementation
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <alpine.LNX.2.00.1210062326150.27782@pobox.suse.cz>
Date: Sat, 6 Oct 2012 23:39:08 +0200
Cc: Jean Delvare <khali@linux-fr.org>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?iso-8859-1?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        =?utf-8?B?5YqJ5ZiJ6ae/?= <scott.liu@emc.com.tw>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, USB list <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <914C6C58-5A3B-4F7D-94BE-EF6868ED5D9D@enac.fr>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>  <20121006220421.47f5fd56@endymion.delvare>  <6F756B9E-DC87-4EF6-BB09-8A69A5F8C999@enac.fr>  <20121006231111.6350c014@endymion.delvare>  <alpine.LNX.2.00.1210062314110.27782@pobox.suse.cz> <alpine.LNX.2.00.1210062326150.27782@pobox.suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 6 oct. 2012 à 23:28, Jiri Kosina a écrit :

> On Sat, 6 Oct 2012, Jiri Kosina wrote:
> 
>>> My vote is a clear 3. It took me a few years to kick all users (as
>>> opposed to implementers) of i2c from drivers/i2c and finding them a
>>> proper home, I'm not going to accept new intruders. Grouping drivers
>>> according to what they implement makes it a lot easier to share code
>>> and ideas between related drivers. If you want to convince yourself,
>>> just imagine the mess it would be if all drivers for PCI devices lived
>>> under drivers/pci.
>> 
>> This is more or less consistent with my original opinion when I was 
>> refactoring the HID layer out of the individual drivers a few years ago.
>> 
>> But Marcel objected that he wants to keep all the bluetooth-related 
>> drivers under net/bluetooth, and I didn't really want to push hard against 
>> this, because I don't have really super-strong personal preference either 
>> way.
>> 
>> But we definitely can use this oportunity to bring this up for discussion 
>> again.
> 
> Basically, to me this all boils down to the question -- what is more 
> important: low-level transport being used, or the general function of the 
> device?
> 
> To me, it's the latter, and as such, everything would belong under 
> drivers/hid.

Then shouldn't is be drivers/input, rather?

St.


