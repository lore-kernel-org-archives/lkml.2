Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1DZTaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:30:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34573 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1DZTaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:30:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OatLaDW29Fr8FfiMBCGCKwlCeZ0eQ7glJugyT73Jp8CtJ4sdjZ3ZENqKH/Qd+Bs7cJ
         T1jKUeDysnV5VXOrAlX4UeMspVI43t2YoJ1JA8Y0tFXX6IreM3LkpJ6d3H4OZZLjo7fN
         k4vMusE7vnXHy+nPRvYX3flm+5KGL9+aW3rSY=
MIME-Version: 1.0
In-Reply-To: <BANLkTin7F21PVKqtbohE6EucdinZ60x5=A@mail.gmail.com>
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>
	<4DB4E94C.2060505@lwfinger.net>
	<BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>
	<4DB5C8FA.2030700@lwfinger.net>
	<BANLkTi=syavY0Tw-Ny9-QhU=_Ryrbmkhfw@mail.gmail.com>
	<4DB61645.8010001@lwfinger.net>
	<BANLkTikWHxEnzZ+H1OgFv7AdmpmmcwVuzA@mail.gmail.com>
	<4DB6E584.9040504@lwfinger.net>
	<BANLkTin7F21PVKqtbohE6EucdinZ60x5=A@mail.gmail.com>
Date: Wed, 27 Apr 2011 03:30:21 +0800
Message-ID: <BANLkTi=MO6u_DOaL8DMvuB5uJybQO_hqWA@mail.gmail.com>
Subject: Re: r8712u cannot set essid
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Content-Type: multipart/mixed; boundary=00248c0d7778e7210c04a1d75a6a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00248c0d7778e7210c04a1d75a6a
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Apr 27, 2011 at 12:24 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> I hacked it a bit more, and now, it's all working. I'll send you the
> patch shortly. Adhoc mode works now, and I've confirmed that my iPhone
> can connect to it, get an IP and surf the net! The device is so tiny
> and was contemplating on trying another brand.

Larry,

Here's the patch for adhoc mode. This should work. Just remember to
set wpa_supplicant's ap_scan to either 1 or 2 (faster association). 0
does not seem to work.

Thanks,
Jeff

--00248c0d7778e7210c04a1d75a6a
Content-Type: application/octet-stream; name=patch-adhoc
Content-Disposition: attachment; filename=patch-adhoc
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmz8cdrk0

LS0tIGxpbnV4LTIuNi9kcml2ZXJzL3N0YWdpbmcvcnRsODcxMi9ydGw4NzF4X2lvY3RsX3NldC5j
CTIwMTAtMTItMjkgMTM6MzY6MDMuMDAwMDAwMDAwICswODAwCisrKyBsaW51eC0yLjYvZHJpdmVy
cy9zdGFnaW5nL3J0bDg3MTIvcnRsODcxeF9pb2N0bF9zZXQuYwkyMDExLTA0LTI3IDAzOjEzOjM5
LjAwMDAwMDAwMCArMDgwMApAQCAtNjgsNyArNjgsMTAgQEAKIAlwbWxtZXByaXYtPmZ3X3N0YXRl
IHw9IF9GV19VTkRFUl9MSU5LSU5HOwogCXBtbG1lcHJpdi0+cHNjYW5uZWQgPSBwbGlzdDsKIAlw
bWxtZXByaXYtPnRvX2pvaW4gPSB0cnVlOwotCWlmIChfcXVldWVfZW1wdHkocXVldWUpID09IHRy
dWUpIHsKKworCS8vIGFkaG9jIG1vZGUgd2lsbCBzdGFydCB3aXRoIGFuIGVtcHR5IHF1ZXVlLCBi
dXQgc2tpcCBjaGVja2luZworCWlmKCFjaGVja19md3N0YXRlKHBtbG1lcHJpdiwgV0lGSV9BREhP
Q19TVEFURSkgJiYKKwkJX3F1ZXVlX2VtcHR5KHF1ZXVlKSA9PSB0cnVlKSB7CiAJCWlmIChwbWxt
ZXByaXYtPmZ3X3N0YXRlICYgX0ZXX1VOREVSX0xJTktJTkcpCiAJCQlwbWxtZXByaXYtPmZ3X3N0
YXRlIF49IF9GV19VTkRFUl9MSU5LSU5HOwogCQkvKiB3aGVuIHNldF9zc2lkL3NldF9ic3NpZCBm
b3IgZG9fam9pbigpLCBidXQgc2Nhbm5pbmcgcXVldWUK
--00248c0d7778e7210c04a1d75a6a--
