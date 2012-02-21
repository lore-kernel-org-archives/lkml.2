Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab2BUA2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 19:28:01 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61567 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2BUA17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 19:27:59 -0500
MIME-Version: 1.0
In-Reply-To: <4F2BBBDA.90900@mvista.com>
References: <1328253259-9343-1-git-send-email-tomoya.rohm@gmail.com>
	<1328253259-9343-3-git-send-email-tomoya.rohm@gmail.com>
	<4F2BBBDA.90900@mvista.com>
Date: Tue, 21 Feb 2012 09:27:59 +0900
Message-ID: <CANKRQng1g_LHVcimKk16VK9SxkNBvC4ZqdThtVWLZgMjgp0KJA@mail.gmail.com>
Subject: Re: [PATCH 3/3] pch_udc: Specifies GPI port number at configuration.
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: multipart/mixed; boundary=047d7b2ee161aff3a104b96e7be5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b2ee161aff3a104b96e7be5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

2012年2月3日19:50 Sergei Shtylyov <sshtylyov@mvista.com>:
>   Isn't it better to pass this with driver's platform data.

To define GPIO port number, we must I'm supporting IntelCrown Bay
platform （Intel AtomE600 + PCH EG20T).
I made an initialization code(attached) for the Crown Bay platform.
Should I post this module to upstream? I need your advice.
If I should do, could you tell me which category we should put
it?

---
ROHM Co., Ltd.
tomoya

--047d7b2ee161aff3a104b96e7be5
Content-Type: text/x-csrc; charset=US-ASCII; name="crownbay.c"
Content-Disposition: attachment; filename="crownbay.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gyw6zq5v0

LyoKICogQ29weXJpZ2h0IChDKSAyMDEyIExBUElTIFNlbWljb25kdWN0b3IgQ28uLCBMdGQuCiAq
CiAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBp
dCBhbmQvb3IgbW9kaWZ5CiAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwg
UHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5CiAqIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5k
YXRpb247IHZlcnNpb24gMiBvZiB0aGUgTGljZW5zZS4KICovCgojaW5jbHVkZSA8bGludXgva2Vy
bmVsLmg+CiNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4K
I2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPgojaW5jbHVkZSA8bGludXgvdXNiL2dw
aW9fdmJ1cy5oPgoKI2RlZmluZSBQQ0hfR1BJT19CQVNFCQkyNDQKCi8qIEdQSU8gZm9yIFVTQiBW
QlVTIGRldGVjdGlvbiAqLwojZGVmaW5lIENST1dOQkFZX0dQSU9fVkJVU19QT1JUCTUKCnN0YXRp
YyBzdHJ1Y3QgZ3Bpb192YnVzX21hY2hfaW5mbyBjcm93bmJheV9ncGlvX3ZidXNfZGF0YSA9IHsK
CS5ncGlvX3ZidXMJPSAoUENIX0dQSU9fQkFTRSArIENST1dOQkFZX0dQSU9fVkJVU19QT1JUKSwK
fTsKCnN0YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlIGNyb3duYmF5X2dwaW9fdmJ1c19kZXZp
Y2UgPSB7CgkubmFtZQkJPSAicGNoLWdwaW8tdmJ1cyIsCgkuaWQJCT0gLTEsCgkuZGV2CQk9IHsK
CQkucGxhdGZvcm1fZGF0YQk9ICZjcm93bmJheV9ncGlvX3ZidXNfZGF0YSwKCX0sCn07CgpzdGF0
aWMgaW50IF9faW5pdCBjcm93bmJheV9wbGF0Zm9ybV9pbml0KHZvaWQpCnsKCWludCByZXR2YWw7
CglyZXR2YWwgPSBwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXIoJmNyb3duYmF5X2dwaW9fdmJ1c19k
ZXZpY2UpOwoJcHJpbnRrKEtFUk5fSU5GTyAiUmVnaXN0ZXJlZCBncGlvLXZidXMgZGV2aWNlIGZv
ciBDcm93biBCYXlcbiIpOwoJcmV0dXJuIHJldHZhbDsKfQptb2R1bGVfaW5pdChjcm93bmJheV9w
bGF0Zm9ybV9pbml0KTsKCnN0YXRpYyB2b2lkIF9fZXhpdCBjcm93bmJheV9wbGF0Zm9ybV9leGl0
KHZvaWQpCnsKCXBsYXRmb3JtX2RldmljZV91bnJlZ2lzdGVyKCZjcm93bmJheV9ncGlvX3ZidXNf
ZGV2aWNlKTsKfQptb2R1bGVfZXhpdChjcm93bmJheV9wbGF0Zm9ybV9leGl0KTsKCk1PRFVMRV9E
RVNDUklQVElPTigiSW50ZWwgQ3Jvd24gQmF5IFBsYXRmb3JtIERyaXZlciIpOwpNT0RVTEVfTElD
RU5TRSgiR1BMIik7Cg==
--047d7b2ee161aff3a104b96e7be5--
