Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0LGPfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:35:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33247 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0LGPfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:35:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t5FLk3zlrM2pmK1JLXdm4C2ndvD8nmJp6PCVIUXpp1dfYCWtGOJKfBBUfMrGhEUsdD
         ikSmWIXyk7ofgrXvNO2C9Vvj92ShDj3ChQTAZb0g/uy4nSYKaWs6RE99MLGY+a6EHVFk
         qfvbS3zkZpFrGTzh+95xcW1+bsznhXTVMm3V0=
Subject: Re: acpi_button: random oops on boot
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        richard.coe@med.ge.com, jslaby@novell.com
In-Reply-To: <1291734122.29072.14.camel@Tobias-Karnat>
References: <1291477752.5096.27.camel@Tobias-Karnat>
	 <201012060928.11307.bjorn.helgaas@hp.com>
	 <1291676503.24968.25.camel@Tobias-Karnat>
	 <201012061626.45962.bjorn.helgaas@hp.com>
	 <1291679699.6246.11.camel@Tobias-Karnat>
	 <20101207051521.GA16804@helgaas.com>
	 <1291734122.29072.14.camel@Tobias-Karnat>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 16:35:30 +0100
Message-ID: <1291736130.29072.19.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 07.12.2010, 16:02 +0100 schrieb Tobias Karnat:
> I have nothing connected to 1-6:
> 
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 003: ID 046d:c20a Logitech, Inc. WingMan RumblePad
> Bus 004 Device 002: ID 03eb:3301 Atmel Corp. at43301 4-Port Hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 003: ID 046d:c062 Logitech, Inc. 
> Bus 002 Device 002: ID 413c:2105 Dell Computer Corp. Model L100 Keyboard
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 001 Device 005: ID 0dda:2026 Integrated Circuit Solution, Inc. USB2.0 Card Reader
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Oh well, it might be the Card Reader.

I also get this:

[  506.822024] usb 1-6: reset high speed USB device using ehci_hcd and address 5
[  661.830024] usb 1-6: reset high speed USB device using ehci_hcd and address 5
[  902.854026] usb 1-6: reset high speed USB device using ehci_hcd and address 5
[ 1309.894029] usb 1-6: reset high speed USB device using ehci_hcd and address 5
[ 1344.814018] usb 1-6: reset high speed USB device using ehci_hcd and address 5
[ 1891.814028] usb 1-6: reset high speed USB device using ehci_hcd and address 5
[ 2736.838021] usb 1-6: reset high speed USB device using ehci_hcd and address 5
[ 2969.830024] usb 1-6: reset high speed USB device using ehci_hcd and address 5
[ 3002.806023] usb 1-6: reset high speed USB device using ehci_hcd and address 5

I will try booting without it, maybe it fixes the boot issue.

But strange that the printk patch could fix this.
And the card reader did work with earlier kernels ~2.6.2x.

-Tobias

