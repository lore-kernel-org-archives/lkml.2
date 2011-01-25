Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1AYW0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:26:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36022 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1AYW0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:26:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GGh8AQb0hHXwZTl1Xb0Fw9PXhtrzdX1x+ypCrS6uU126c4o53bzjEgMVrzDkjEmVXY
         Mc4fEo2/StzAqeZrXZy94sLVQpt5wjTTg7aDeRYvgYtSfm2kFrtYw+fCNoPm9+TRvur7
         PhkbdhD8JYZ1u5kTlvzaeyQPmnXy1GAqagNII=
MIME-Version: 1.0
In-Reply-To: <20110125151346.GB14803@khazad-dum.debian.net>
References: <Pine.LNX.4.64.1101251740380.3737@boston.corp.fedex.com>
	<20110125151346.GB14803@khazad-dum.debian.net>
Date: Wed, 26 Jan 2011 06:26:53 +0800
Message-ID: <AANLkTim9cN8KXx5DVrH_nBzVjnmuYsxOHwP4msBKs=gS@mail.gmail.com>
Subject: Re: thinkpad-acpi: fn-f4 issues
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, Dominik Kopp <my@kabelfunk.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:13 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> That will basicaly lobotomize the driver, as the "hotkeys" are really the
> entire firmware event interface(!).

Didn't know that.

> Which thinkpad do you have that need CONFIG_THINKPAD_ACPI_HOTKEY_POLL to
> handle Fn+F4?   I don't expect that to be needed on anything newer than a
> T32...

X201s which is quite new.


> Can I have the full kernel log, please?

thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 6QET62WW (1.32 ), EC 6QHT31WW-1.12
thinkpad_acpi: Lenovo ThinkPad X201s, model 5413FGA
thinkpad_acpi: detected a 8-level brightness capable ThinkPad
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi::standby
Registered led device: tpacpi::thinkvantage
thinkpad_acpi: volume: disabled as there is no ALSA support in this kernel
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5

And the volume up/down does not work either even with thinkpad ALSA
support enabled.

Thanks,
Jeff.
