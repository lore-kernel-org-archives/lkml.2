Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0KWQed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 11:34:33 -0500
Received: from ns1.dataart.com ([195.206.224.40]:63912 "EHLO
	relay1.dataart.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755684Ab0KWQeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 11:34:31 -0500
From: Anton Chikin <Anton.Chikin@dataart.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: "chatty@enac.fr" <chatty@enac.fr>, "spbnick@gmail.com" <spbnick@gmail.com>,
        "anisse@astier.eu" <anisse@astier.eu>,
        "cascardo@holoscopio.com" <cascardo@holoscopio.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Gregory Burmistrov <grig@dataart.com>
Date: Tue, 23 Nov 2010 19:34:25 +0300
Subject: RE: [PATCH] hid: usbhid: New hid quirks for Panasonic Elite
 Panaboard T-780 and T-880
Thread-Topic: [PATCH] hid: usbhid: New hid quirks for Panasonic Elite
 Panaboard T-780 and T-880
Thread-Index: AcuLEk0TuxBZgZtsR9yTu6sF/MJzYQAGF+ng
Message-ID: <3BF066A8BAB61C43B779966CEE6D7FA019E8B47193@e6.universe.dart.spb>
References: <1288169825-15422-1-git-send-email-Anton.Chikin@dataart.com>
 <alpine.LNX.2.00.1010291453460.6879@pobox.suse.cz>
 <3BF066A8BAB61C43B779966CEE6D7FA018BC9E19F2@e6.universe.dart.spb>
 <alpine.LNX.2.00.1011011522120.15851@pobox.suse.cz>
 <3BF066A8BAB61C43B779966CEE6D7FA018BC9E1A45@e6.universe.dart.spb>
 <alpine.LNX.2.00.1011030925310.15851@pobox.suse.cz>
 <3BF066A8BAB61C43B779966CEE6D7FA018BC9E1C10@e6.universe.dart.spb>
 <alpine.LNX.2.00.1011231427090.18801@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1011231427090.18801@pobox.suse.cz>
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

Hi Jiri,

>Hi,
>
>that's a bit strange. If you modprobe the module manually, does it get 
>bound to the device and works properly?
I've tried modprobe with no effect. Moreover I've inserted printk() into hid_bus_match() and hid_device_probe() to track devices processed by these functions - my device is never listed there.
I've rolled back to 2.6.31 standard Ubuntu kernel and everything gone ok - probe() was called. Maybe I've missed something while configuring and installing new kernel?

>Could you please send me the complete diff, including the changes to 
>drivers/hid/hid-core.c?
I've sent you all my changes as a patch in a separate letter.

Thank you for your attention.

With best regards,
Anton Chikin
