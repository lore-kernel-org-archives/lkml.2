Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0KCN2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:28:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab0KCN2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:28:16 -0400
Date: Wed, 3 Nov 2010 09:28:14 -0400 (EDT)
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
In-Reply-To: <3BF066A8BAB61C43B779966CEE6D7FA018BC9E1A45@e6.universe.dart.spb>
Message-ID: <alpine.LNX.2.00.1011030925310.15851@pobox.suse.cz>
References: <1288169825-15422-1-git-send-email-Anton.Chikin@dataart.com> <alpine.LNX.2.00.1010291453460.6879@pobox.suse.cz> <3BF066A8BAB61C43B779966CEE6D7FA018BC9E19F2@e6.universe.dart.spb> <alpine.LNX.2.00.1011011522120.15851@pobox.suse.cz>
 <3BF066A8BAB61C43B779966CEE6D7FA018BC9E1A45@e6.universe.dart.spb>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010, Anton Chikin wrote:

> Thank you for your feedback.
> 
> With the generic hid driver device is working in mouse-mode, turning it 
> into the huge touchscreen, which is completely useless for the end-user.

Still, at least some very basic and limited/crippled functionality is 
there. So my preferred mode of operation now would be having the device 
being claimed by generic driver and wait for your proper full-fledged 
driver.

> On some Linux systems hid driver is loaded from init.rd image, so we 
> can't feed our quirks to it while boot process and we can't rebuild 
> init.rd image on the user's machine because some Linux distributives 
> doesn't have special tools preinstalled.
> 
> We are going to submit our driver to the Linux kernel quickly, so 
> everyone can improve it.

That would be great, I'll be happy to review and merge it. Are you 
planning to have it as a driver on HID bus, or completely separate USB 
driver?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
