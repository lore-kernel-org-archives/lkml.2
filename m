Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab1DYCQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 22:16:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39174 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab1DYCQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 22:16:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=K1LW8wx6303nvj/PlZuArGGCIrw8LKBMt3EejV2T/pw18IdAd3mSRUkX7jiAMiZdRD
         n36tsVZVNCLot0iaw6YEGDa/1C2eFGsmrAf0GwvTfBz6kYx2ps9JjJd6a+SIyehKBkKn
         bzYjyc4ZJ20mzcBJ2iD/O/UGPN7OUZCzlzB9U=
MIME-Version: 1.0
Date: Mon, 25 Apr 2011 10:16:09 +0800
Message-ID: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>
Subject: r8712u cannot set essid
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com,
        Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having problem trying to set essid on the "Realtek RTL8188S WLAN
Adapter" with the r8172u module on 2.6.39-rc4. There's no error. Just
can't set.


# dmesg ...
r8712u: module is from the staging directory, the quality is unknown,
you have been warned.
r8712u: DriverVersion: v7_0.20100831
r8712u: register rtl8712_netdev_ops to netdev_ops
r8712u: USB_SPEED_HIGH with 4 endpoints
r8712u: Boot from EFUSE: Autoload OK
r8712u: CustomerID = 0x0000
r8712u: MAC Address from efuse = 90:61:0c:01:8f:b0
usbcore: registered new interface driver r8712u
r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
r8712u: 1 RCR=0x153f00e
r8712u: 2 RCR=0x553f00e

# iwconfig wlan1 essid "tryanything"
# iwconfig wlan1
wlan1     IEEE 802.11b  ESSID:""  Nickname:"rtl_wifi"
          Mode:Ad-Hoc  Cell: Not-Associated   Bit Rate:0 kb/s
          Sensitivity:0/0
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0



Thanks,
Jeff
