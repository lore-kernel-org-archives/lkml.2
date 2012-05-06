Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2EFQyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 12:54:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48060 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2EFQyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 12:54:53 -0400
Message-ID: <4FA6ACD9.6010907@gmail.com>
Date: Sun, 06 May 2012 19:54:49 +0300
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] hid: Enable report fixup on rebind
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1204222325380.1856@pobox.suse.cz> <4FA6AC46.20701@gmail.com>
In-Reply-To: <4FA6AC46.20701@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040906080404020805030206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040906080404020805030206
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/06/2012 07:52 PM, Nikolai Kondrashov wrote:
> I've managed to throw together a script which rebinds a device to a specific
> out-of-tree HID driver automatically. Please find it attached. I'll be
> bundling it with the modules, probably.

Now with proper indentation, sorry.

Sincerely,
Nick

--------------040906080404020805030206
Content-Type: text/plain;
 name="digimend-rebind"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="digimend-rebind"

IyEvYmluL3NoCiMKIyBESUdJbWVuZCBzcGVjaWZpYyBkcml2ZXIgcmViaW5kaW5nIHNjcmlw
dC4gVG8gYmUgaW52b2tlZCBieSB1ZGV2LgojIEF1dGhvcjogTmlrb2xhaSBLb25kcmFzaG92
IDxzcGJuaWNrQGdtYWlsLmNvbT4KIwojIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJl
OiB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CiMgaXQgdW5kZXIgdGhl
IHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQg
YnkKIyB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLCBlaXRoZXIgdmVyc2lvbiAyIG9m
IHRoZSBMaWNlbnNlLCBvcgojIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24u
CiMKIyBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3
aWxsIGJlIHVzZWZ1bCwKIyBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZl
biB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgojIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNT
IEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUKIyBHTlUgR2VuZXJhbCBQdWJs
aWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgojCiMgWW91IHNob3VsZCBoYXZlIHJlY2Vp
dmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKIyBhbG9uZyB3
aXRoIHRoaXMgcHJvZ3JhbS4gIElmIG5vdCwgc2VlIDxodHRwOi8vd3d3LmdudS5vcmcvbGlj
ZW5zZXMvPi4KIwoKIyBXcml0ZSBhIHN0cmluZyB0byBhIGZpbGUsIGlnbm9yaW5nIEVOT0RF
Vi4Kd3JpdGVfaWdub3JlX2Vub2RldigpIHsKICAgIGxvY2FsIHN0cj0iJDEiCiAgICBsb2Nh
bCBwYXRoPSIkMiIKICAgIGxvY2FsIG91dHB1dD0iIgoKICAgICMgV3JpdGUgdGhlIHN0cmlu
ZyB3aXRoIHRlZSwgY2FwdHVyaW5nIGVycm9yIG91dHB1dAogICAgaWYgISBvdXRwdXQ9ImAo
ZWNobyBcIiRzdHJcIiB8IHRlZSBcIiRwYXRoXCIgPi9kZXYvbnVsbCkgMj4mMWAiOyB0aGVu
CiAgICAgICAgIyBSYWlzZSBhbnl0aGluZyBleGNlcHQgRU5PREVWCiAgICAgICAgaWYgWyAi
JHtvdXRwdXQjIyo6IH0iICE9ICJObyBzdWNoIGRldmljZSIgXTsgdGhlbgogICAgICAgICAg
ICBlY2hvICIkb3V0cHV0IiA+JjIKICAgICAgICAgICAgcmV0dXJuIDEKICAgICAgICBmaQog
ICAgZmkKfQoKKAogICAgc2V0IC1lIC11CgogICAgcHJvZ25hbWU9ImBiYXNlbmFtZSBcIiQw
XCJgIgoKICAgIGlkPSJgYmFzZW5hbWUgJERFVlBBVEhgIgoKICAgIGN1cnJlbnRfZHJpdmVy
X3BhdGg9ImByZWFkbGluayAtdiAtZiAvc3lzJHtERVZQQVRIfS9kcml2ZXJgIgogICAgaWYg
WyAtZSAiJGN1cnJlbnRfZHJpdmVyX3BhdGgiIF07IHRoZW4KICAgICAgICBjdXJyZW50X2Ry
aXZlcj0iYGJhc2VuYW1lIFwiJGN1cnJlbnRfZHJpdmVyX3BhdGhcImAiCiAgICBlbHNlCiAg
ICAgICAgY3VycmVudF9kcml2ZXI9IiIKICAgIGZpCgogICAgc3BlY2lmaWNfbW9kdWxlPSJg
bW9kcHJvYmUgLVIgJE1PREFMSUFTYCIKCiAgICAjIEFzc3VtZSB0aGUgZHJpdmVyIHdvdWxk
IGJlIGNhbGxlZCB0aGUgc2FtZSBhcyBtb2R1bGUsCiAgICAjIGJ1dCB3aXRob3V0IHRoZSAi
aGlkXyIgb3IgImhpZC0iIHByZWZpeAogICAgc3BlY2lmaWNfZHJpdmVyPSIke3NwZWNpZmlj
X21vZHVsZSNoaWRbXy1dfSIKICAgIHNwZWNpZmljX2RyaXZlcl9wYXRoPSIvc3lzL2J1cy9o
aWQvZHJpdmVycy8kc3BlY2lmaWNfZHJpdmVyIgoKICAgIGlmIFsgIiRjdXJyZW50X2RyaXZl
ciIgIT0gIiRzcGVjaWZpY19kcml2ZXIiIF07IHRoZW4KICAgICAgICBsb2dnZXIgLXAgZGFl
bW9uLm5vdGljZSAtdCAiJHByb2duYW1lIiAicmViaW5kaW5nICRERVZQQVRIIgoKICAgICAg
ICAjIEVuc3VyZSB0aGUgc3BlY2lmaWMgZHJpdmVyIG1vZHVsZSBpcyBsb2FkZWQKICAgICAg
ICBtb2Rwcm9iZSAiJHNwZWNpZmljX21vZHVsZSIKCiAgICAgICAgIyBVbmJpbmQgZnJvbSB0
aGUgY3VycmVudCBkcml2ZXIsIGlmIGFueQogICAgICAgIGlmIFsgLW4gIiRjdXJyZW50X2Ry
aXZlciIgXTsgdGhlbgogICAgICAgICAgICB3cml0ZV9pZ25vcmVfZW5vZGV2ICIkaWQiICIk
Y3VycmVudF9kcml2ZXJfcGF0aC91bmJpbmQiCiAgICAgICAgZmkKCiAgICAgICAgIyBCaW5k
IHRvIHRoZSBzcGVjaWZpYyBkcml2ZXIKICAgICAgICB3cml0ZV9pZ25vcmVfZW5vZGV2ICIk
aWQiICIkc3BlY2lmaWNfZHJpdmVyX3BhdGgvYmluZCIKICAgIGZpCikgMj4mMSB8IGxvZ2dl
ciAtcCBkYWVtb24ud2FybmluZyAtdCAiJHByb2duYW1lIgo=
--------------040906080404020805030206--
