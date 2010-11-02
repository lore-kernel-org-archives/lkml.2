Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0KBNGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:06:09 -0400
Received: from ns1.dataart.com ([195.206.224.40]:61408 "EHLO
	relay1.dataart.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750820Ab0KBNGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:06:02 -0400
From: Anton Chikin <Anton.Chikin@dataart.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: "chatty@enac.fr" <chatty@enac.fr>, "spbnick@gmail.com" <spbnick@gmail.com>,
        "anisse@astier.eu" <anisse@astier.eu>,
        "cascardo@holoscopio.com" <cascardo@holoscopio.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Gregory Burmistrov <grig@dataart.com>,
        Paul Osborn <Paul.Osborn@eu.panasonic.com>
Date: Tue, 2 Nov 2010 16:05:54 +0300
Subject: RE: [PATCH] hid: usbhid: New hid quirks for Panasonic Elite
 Panaboard T-780 and T-880
Thread-Topic: [PATCH] hid: usbhid: New hid quirks for Panasonic Elite
 Panaboard T-780 and T-880
Thread-Index: Act5+h5driK4u/BuSkm6Z9Y3EMqXjgAjnaCw
Message-ID: <3BF066A8BAB61C43B779966CEE6D7FA018BC9E1A45@e6.universe.dart.spb>
References: <1288169825-15422-1-git-send-email-Anton.Chikin@dataart.com>
 <alpine.LNX.2.00.1010291453460.6879@pobox.suse.cz>
 <3BF066A8BAB61C43B779966CEE6D7FA018BC9E19F2@e6.universe.dart.spb>
 <alpine.LNX.2.00.1011011522120.15851@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1011011522120.15851@pobox.suse.cz>
Accept-Language: ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ru-RU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiri,

Thank you for your feedback.

With the generic hid driver device is working in mouse-mode, turning it into the huge touchscreen, which is completely useless for the end-user.

Moreover, the device has internal modes(mouse mode and touch mode) which we need to switch during work.

On some Linux systems hid driver is loaded from init.rd image, so we can't feed our quirks to it while boot process and we can't rebuild init.rd image on the user's machine because some Linux distributives doesn't have special tools preinstalled.

We are going to submit our driver to the Linux kernel quickly, so everyone can improve it.

Any comments and suggestions are greatly appreciated.

With best regards,
Anton Chikin


-----Original Message-----
From: Jiri Kosina [mailto:jkosina@suse.cz] 
Sent: Monday, November 01, 2010 10:22 PM
To: Anton Chikin
Cc: chatty@enac.fr; spbnick@gmail.com; anisse@astier.eu; cascardo@holoscopio.com; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; Gregory Burmistrov; Paul Osborn
Subject: RE: [PATCH] hid: usbhid: New hid quirks for Panasonic Elite Panaboard T-780 and T-880

On Fri, 29 Oct 2010, Anton Chikin wrote:

> Hello Jiri,
> 
> Panasonic Elite Panaboard UB-T780 is a touchscreen whiteboard. It uses 
> projector to present PC's screen onto the board. So we need to calibrate 
> it according to the projector's position and apply calibration data 
> inside our driver.
> 
> There is no other driver for this device. I'm working directly for 
> Panasonic on this driver.
> 
> Is this nice for changelog comment?

If the device is 'working' properly with the generic driver, "only" not 
properly calibrated, I wouldn't really like to blacklist it completely.

It might impose regression for those users who have written their own 
userspace calibration, for example.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
