Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2D0Hq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:46:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61051 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2D0Hq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:46:58 -0400
Message-ID: <4F9A4EED.20800@suse.cz>
Date: Fri, 27 Apr 2012 09:46:53 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Steffen_M=FCller?= <steffen.mueller@radio-frei.de>
CC: opensuse-factory@opensuse.org, stable@kernel.org, Greg KH <greg@kroah.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: usb midi keyboard broken [3.3.3 regression]
References: <1571281.mVArydTEZW@thinkpadsm.rf-studio> <87haw6z4ps.fsf@Rainer.invalid> <4F99BD60.1060303@suse.cz> <1972516.Nxci8jDpSI@thinkpadsm.rf-studio>
In-Reply-To: <1972516.Nxci8jDpSI@thinkpadsm.rf-studio>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/27/2012 09:37 AM, Steffen Müller wrote:
>> [  224.418062] usb 1-1.3: USB disconnect, device number 6 [
>> 227.662396] usb 1-1.3: new full-speed USB device number 7 using
>> ehci_hcd [  227.749541] usb 1-1.3: New USB device found,
>> idVendor=0763, idProduct=0192 [  227.749550] usb 1-1.3: New USB
>> device strings: Mfr=1, Product=2, SerialNumber=0 [  227.749556]
>> usb 1-1.3: Product: USB Keystation 88es [  227.749560] usb 1-1.3:
>> Manufacturer: M-Audio [  229.750236] ALSA midi.c:214 urb status
>> -32 [  229.750700] ALSA midi.c:214 urb status -32 [  229.750911]
>> ALSA midi.c:214 urb status -32 [  229.751175] ALSA midi.c:214 urb
>> status -32 [  229.751413] ALSA midi.c:214 urb status -32 [
>> 229.751659] ALSA midi.c:214 urb status -32 [  229.751910] ALSA
>> midi.c:214 urb status -32 [  229.752210] ALSA midi.c:214 urb
>> status -32 [  229.752459] ALSA midi.c:214 urb status -32 [
>> 229.752662] ALSA midi.c:214 urb status -32

Hmm... I suspect some USB patches added in 3.3.3... Alan, Greg, any ideas?

3.3.2 is reported to work.

thanks,
- -- 
js
suse labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPmk7tAAoJEL0lsQQGtHBJRjMQAISHi8yIkLvpJDZjKM/uY5px
II9wXE8D4rhgjXaeOADFS92lPyaLES1IJYRudh5QRRsOfguU7y0iZSbqukpaaJse
EOcQSRvtKjzQOn0qmvAuYDORYLWELJG+TDeMas+4ecBFygEmzIAkmgULJsw1dkQR
L7H7B+pVL9lKdBQg0annMxxqPkxbrRL8kYu4ZkNOLhKdk6SNcMw4KBq7xVQc1Jfa
GwDdHdpE6/2D9UE4fiEU4q7FTCeF+on1GYnpw8+P6CJT2ovNcp0GF1TeW4q5yAMx
YgkOjyUXzYnbz5j9jHVkZgOgCXKudj/AdexuehMnC+YXqPFG40cc0KHWHhBh5LbG
7TJ6zJ0bby7yazk3mV1P099eR6YinB7zsHWHhW6COwh4t6ZeWOAQVUbL2mAFoOZy
Dq9S8wVnQKj+/M5ewWjTnX6yVbySJ/wDfVRx+HRiyEvARqFyHC9EdAsQG+aHHlU1
RDu+56CprOnkvsNXaZUabRUZVfOyVfpYeWBXEkcd8nSDmqUnnOUpgy4035YjTsAf
MU8ph+r3PqepDyjW1uaE+CTApGjD38Dxrt070yxtqOhBntBZp/WXYUkDq5BQEcnr
o35xfluDIiUQzhYzbO92Qr+MA03moVcQXG72s+2cnAWdTw5+zo3VCHfEgZtdpmFN
2mRV1ljPbjt9314rGTXv
=vE/l
-----END PGP SIGNATURE-----
