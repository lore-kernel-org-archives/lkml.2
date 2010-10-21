Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0JURvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:51:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61178 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab0JURvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:51:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ArQV7rC4GwHtwtU0eK763OassfX2/Q+SG17EDxCOFV4cMqu6Cqs7yHRjtymhzZqH+y
         w7bZgXS+Cpcxlet/+qsmm0XtN7qnCZMIcj0qDYnjVnQPGISEaogSnmsojAgk0EQzhhsV
         ADSFJZHnUXQsuQuJ5DVlzBPcKHZfCePzm6qrA=
Message-ID: <4CC07DB4.20205@gmail.com>
Date: Thu, 21 Oct 2010 19:51:48 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>
Subject: DVB: af9015 defunct [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
In-Reply-To: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 12:01 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-10-20-15-01 has been uploaded to

Well, this release happens to be a multimedia failure :(.

I hit another regression against mmotm 2010-10-13-17-13, where
0413:6029 (DVB USB tuner) can't be inited when plugged in. Even lsusb
waits inifitely.

usb 2-6: new high speed USB device using ehci_hcd and address 5
dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in cold state, will
try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Leadtek WinFast DTV Dongle Gold)
af9013: firmware version:4.95.0.0
DVB: registering adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
tda18271 18-00c0: creating new instance
TDA18271HD/C2 detected @ 18-00c0
af9015: command failed:1
tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x0, len = 39,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
i2c_transfer returned: -1
af9015: command failed:1
tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x20, len = 1,
i2c_transfer returned: -1
af9015: recv bulk message failed:-71
af9015: bulk message failed:-71 (8/0)
af9013: I2C read failed reg:d417
tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x5, len = 11,
i2c_transfer returned: -1
af9015: bulk message failed:-71 (8/0)
af9013: I2C read failed reg:d417
af9015: bulk message failed:-71 (9/0)
af9015: bulk message failed:-71 (8/0)
af9013: I2C read failed reg:d417
tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x13, len = 1,
i2c_transfer returned: -71
af9015: bulk message failed:-71 (8/0)
af9013: I2C read failed reg:d417
af9015: bulk message failed:-71 (9/0)
af9015: bulk message failed:-71 (8/0)
af9013: I2C read failed reg:d417
tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x13, len = 1,
i2c_transfer returned: -71

regards,
-- 
js
