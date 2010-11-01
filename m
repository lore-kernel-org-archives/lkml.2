Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab0KATW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:22:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0KATWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:22:25 -0400
Date: Mon, 1 Nov 2010 15:22:22 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Anton Chikin <Anton.Chikin@dataart.com>
Cc: "chatty@enac.fr" <chatty@enac.fr>, "spbnick@gmail.com" <spbnick@gmail.com>,
        "anisse@astier.eu" <anisse@astier.eu>,
        "cascardo@holoscopio.com" <cascardo@holoscopio.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Gregory Burmistrov <grig@dataart.com>,
        Paul Osborn <Paul.Osborn@eu.panasonic.com>
Subject: RE: [PATCH] hid: usbhid: New hid quirks for Panasonic Elite Panaboard
 T-780 and T-880
In-Reply-To: <3BF066A8BAB61C43B779966CEE6D7FA018BC9E19F2@e6.universe.dart.spb>
Message-ID: <alpine.LNX.2.00.1011011522120.15851@pobox.suse.cz>
References: <1288169825-15422-1-git-send-email-Anton.Chikin@dataart.com> <alpine.LNX.2.00.1010291453460.6879@pobox.suse.cz> <3BF066A8BAB61C43B779966CEE6D7FA018BC9E19F2@e6.universe.dart.spb>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
