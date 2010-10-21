Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab0JUWYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:24:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65451 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0JUWYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Y3LyTxzsb5noWH3F5RC1FDjxcFtXpUSUVIaz3Scynk6N3xYJGtV0PKiQRVCSSlMeKM
         j/uAXLLNjFj2sxAbyN2zLugsVlVsx/Hwv4SXYHHTM9Gz/4gaHU+oxgN72HCb1lYyeSkI
         B0o3TmE86yZUSj1zO/gsTOFVAWNC8ZC4oQ1kA=
Message-ID: <4CC0BD9C.8000203@gmail.com>
Date: Fri, 22 Oct 2010 00:24:28 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: DVB: af9015 defunct [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CC07DB4.20205@gmail.com>
In-Reply-To: <4CC07DB4.20205@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 07:51 PM, Jiri Slaby wrote:
> On 10/21/2010 12:01 AM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2010-10-20-15-01 has been uploaded to
> 
> Well, this release happens to be a multimedia failure :(.
> 
> I hit another regression against mmotm 2010-10-13-17-13, where
> 0413:6029 (DVB USB tuner) can't be inited when plugged in. Even lsusb
> waits inifitely.

Revert of the af9015 changes doesn't seem to help.

> usb 2-6: new high speed USB device using ehci_hcd and address 5
> dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in cold state, will
> try to load a firmware
> dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (Leadtek WinFast DTV Dongle Gold)
> af9013: firmware version:4.95.0.0
> DVB: registering adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
> tda18271 18-00c0: creating new instance
> TDA18271HD/C2 detected @ 18-00c0
> af9015: command failed:1
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x0, len = 39,
> i2c_transfer returned: -1
> af9015: command failed:1
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
> i2c_transfer returned: -1
> af9015: command failed:1
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
> i2c_transfer returned: -1
> af9015: command failed:1
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
> i2c_transfer returned: -1
> af9015: command failed:1
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
> i2c_transfer returned: -1
> af9015: recv bulk message failed:-71
> af9015: bulk message failed:-71 (8/0)
> af9013: I2C read failed reg:d417
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x5, len = 11,
> i2c_transfer returned: -1
> af9015: bulk message failed:-71 (8/0)
> af9013: I2C read failed reg:d417
> af9015: bulk message failed:-71 (9/0)
> af9015: bulk message failed:-71 (8/0)
> af9013: I2C read failed reg:d417
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x13, len = 1,
> i2c_transfer returned: -71
> af9015: bulk message failed:-71 (8/0)
> af9013: I2C read failed reg:d417
> af9015: bulk message failed:-71 (9/0)
> af9015: bulk message failed:-71 (8/0)
> af9013: I2C read failed reg:d417
> tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x13, len = 1,
> i2c_transfer returned: -71
> 
> regards,


-- 
js
