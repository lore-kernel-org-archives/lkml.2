Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab0JDEeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 00:34:03 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:45989 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab0JDEeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 00:34:01 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <gregkh@suse.de>,
        Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Regarding USB-to-serial device driver
Date: Mon, 4 Oct 2010 10:03:40 +0530
Message-Id: <20101004042924.M50398@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20100928120743.GA15807@suse.de>
References: <20100913154843.GA27496@suse.de> <20100914060649.M96376@admin-gateway.ncra.tifr.res.in> <20100914131925.GC375@suse.de> <20100922052107.M44650@admin-gateway.ncra.tifr.res.in> <20100922145607.GB26309@suse.de> <20100923100127.M64470@admin-gateway.ncra.tifr.res.in> <20100923140236.GB31394@suse.de> <20100928091520.M79654@admin-gateway.ncra.tifr.res.in> <20100928113036.GA15024@suse.de> <20100928115204.M46802@admin-gateway.ncra.tifr.res.in> <20100928120743.GA15807@suse.de>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=OPENWEBMAIL_ATT_0.136613861980976"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=OPENWEBMAIL_ATT_0.136613861980976
Content-Type: text/plain;
	charset=utf-8


Hi Greg,

> > Is it possible to control RTS line from user space.
> 
> Yes.
 
It's  possible to control RTS line for standard UART serial port like ttyS0 and ttyS1
from userspace.

But for USB-to-serial port like ttyUSB0, the program is not able to control RTS line
from userspace.

I have attached the userspace program for enable/disable of RTS line.

Thanks-

Raj

------=OPENWEBMAIL_ATT_0.136613861980976
Content-Type: text/x-csrc;
	name="Test.c"
Content-Disposition: attachment; filename="Test.c"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHRlcm1pb3Mu
aD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3lzL2lvY3RsLmg+CiNpbmNsdWRlIDxz
eXMvdHlwZXMuaD4KI2luY2x1ZGUgPHN5cy9zdGF0Lmg+CiNpbmNsdWRlIDxmY250bC5oPgoKCnN0
YXRpYyBzdHJ1Y3QgdGVybWlvcyBvbGR0ZXJtaW5mbzsKCgp2b2lkIGNsb3Nlc2VyaWFsKGludCBm
ZCkKewogICAgdGNzZXRhdHRyKGZkLCBUQ1NBTk9XLCAmb2xkdGVybWluZm8pOwogICAgaWYgKGNs
b3NlKGZkKSA8IDApCiAgICAgICAgcGVycm9yKCJjbG9zZXNlcmlhbCgpIik7Cn0KCgppbnQgb3Bl
bnNlcmlhbChjaGFyICpkZXZpY2VuYW1lKQp7CiAgICBpbnQgZmQ7CiAgICBzdHJ1Y3QgdGVybWlv
cyBhdHRyOwoKICAgIGlmICgoZmQgPSBvcGVuKGRldmljZW5hbWUsIE9fUkRXUikpID09IC0xKSB7
CiAgICAgICAgcGVycm9yKCJvcGVuc2VyaWFsKCk6IG9wZW4oKSIpOwogICAgICAgIHJldHVybiAw
OwogICAgfQogICAgaWYgKHRjZ2V0YXR0cihmZCwgJm9sZHRlcm1pbmZvKSA9PSAtMSkgewogICAg
ICAgIHBlcnJvcigib3BlbnNlcmlhbCgpOiB0Y2dldGF0dHIoKSIpOwogICAgICAgIHJldHVybiAw
OwogICAgfQogICAgYXR0ciA9IG9sZHRlcm1pbmZvOwogICAgYXR0ci5jX2NmbGFnIHw9IENSVFND
VFMgfCBDTE9DQUw7CiAgICBhdHRyLmNfb2ZsYWcgPSAwOwogICAgaWYgKHRjZmx1c2goZmQsIFRD
SU9GTFVTSCkgPT0gLTEpIHsKICAgICAgICBwZXJyb3IoIm9wZW5zZXJpYWwoKTogdGNmbHVzaCgp
Iik7CiAgICAgICAgcmV0dXJuIDA7CiAgICB9CiAgICBpZiAodGNzZXRhdHRyKGZkLCBUQ1NBTk9X
LCAmYXR0cikgPT0gLTEpIHsKICAgICAgICBwZXJyb3IoImluaXRzZXJpYWwoKTogdGNzZXRhdHRy
KCkiKTsKICAgICAgICByZXR1cm4gMDsKICAgIH0KICAgIHJldHVybiBmZDsKfQoKCmludCBzZXRS
VFMoaW50IGZkLCBpbnQgbGV2ZWwpCnsKICAgIGludCBzdGF0dXM7CgogICAgaWYgKGlvY3RsKGZk
LCBUSU9DTUdFVCwgJnN0YXR1cykgPT0gLTEpIHsKICAgICAgICBwZXJyb3IoInNldFJUUygpOiBU
SU9DTUdFVCIpOwogICAgICAgIHJldHVybiAwOwogICAgfQogICAgaWYgKGxldmVsKQogICAgICAg
IHN0YXR1cyB8PSBUSU9DTV9SVFM7CiAgICBlbHNlCiAgICAgICAgc3RhdHVzICY9IH5USU9DTV9S
VFM7CiAgICBpZiAoaW9jdGwoZmQsIFRJT0NNU0VULCAmc3RhdHVzKSA9PSAtMSkgewogICAgICAg
IHBlcnJvcigic2V0UlRTKCk6IFRJT0NNU0VUIik7CiAgICAgICAgcmV0dXJuIDA7CiAgICB9CiAg
ICByZXR1cm4gMTsKfQoKCmludCBtYWluKCkKewogICAgaW50IGZkOwogICAgY2hhciAqc2VyaWFs
ZGV2ID0gIi9kZXYvdHR5VVNCMCI7CgogICAgZmQgPSBvcGVuc2VyaWFsKHNlcmlhbGRldik7CiAg
ICBpZiAoIWZkKSB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJFcnJvciB3aGlsZSBpbml0aWFs
aXppbmcgJXMuXG4iLCBzZXJpYWxkZXYpOwogICAgICAgIHJldHVybiAxOwogICAgfQoKICAgIHNl
dFJUUyhmZCwxKTsKICAgIHVzbGVlcCgxKTsgICAgICAKICAgIHNldFJUUyhmZCwgMCk7CgogICAg
Y2xvc2VzZXJpYWwoZmQpOwogICAgcmV0dXJuIDA7Cn0=

------=OPENWEBMAIL_ATT_0.136613861980976--
