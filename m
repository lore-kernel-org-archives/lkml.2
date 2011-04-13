Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab1DMFGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 01:06:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62365 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1DMFGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 01:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FKe0BatLSTi7lW/CEuX3XbDBcw6H1k2Z5SraRsJF7LSc+umC5hEXH2n81J7BPNNY7B
         J1+aE7hUUQbow5ZrewR/PXyLRf7/luRh11iPggD3h7xgRocS9Sbai5VjkA8kEV7CSHTd
         0FsR4NV5c5jLf9L+f3+qdujnht84e2vJHxWNQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=AOvVELYKA=BSTsOLbzfZyDg8UaQ@mail.gmail.com>
References: <20110413031904.9276.qmail@science.horizon.com>
	<BANLkTi=AOvVELYKA=BSTsOLbzfZyDg8UaQ@mail.gmail.com>
Date: Wed, 13 Apr 2011 09:06:11 +0400
Message-ID: <BANLkTi=k0GMrWV5covpnGBfB30UO14z-HA@mail.gmail.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2d on CPU 0.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: George Spelvin <linux@horizon.com>
Cc: airlied@gmail.com, dzickus@redhat.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, eranian@google.com,
        sruffell@digium.com
Content-Type: multipart/mixed; boundary=001636e0ae486a936204a0c5c44a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e0ae486a936204a0c5c44a
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Apr 13, 2011 at 8:34 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> There is a patch fromDon we are testing now, i will resend it in a couple of
> hours.
>

George, mind to give these patches a shot please? (Sorry for sending
it as attachment).

--001636e0ae486a936204a0c5c44a
Content-Type: application/octet-stream; name="don-apic-nmi-unmask-fix.patch"
Content-Disposition: attachment; filename="don-apic-nmi-unmask-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmfspjbd0

RnJvbTogRG9uIFppY2t1cyA8ZHppY2t1c0ByZWRoYXQuY29tPgpEYXRlOiBUdWUsIDEyIEFwciAy
MDExIDEyOjMwOjMxIC0wNDAwClN1YmplY3Q6IFtQQVRDSF0gcGVyZiwgeDg2OiBmaXggdW5rbm93
biBOTUlzIG9uIGEgUGVudGl1bTQgYm94CgpXaGVuIHVzaW5nIHBlcmYgb24gYSBQZW50aXVtNCBi
b3gsIGxvdHMgb2YgdW5rbm93biBOTUlzIHdvdWxkIGJlIGdlbmVyYXRlZC4KVGhpcyBpcyB0aGUg
cmVzdWx0IG9mIGEgUDQgcXVpcmsgdGhhdCBpcyBzdWJ0bGUuICBUaGUgUDQgZ2VuZXJhdGVzIGFu
IE5NSQp3aGVuIHRoZSBjb3VudGVyIG92ZXJmbG93IGFuZCB1bmxpa2Ugb3RoZXIgYXJjaGVzIHdo
ZXJlIHRoZSBOTUkgaXMgYSBvbmUgdGltZQpldmVudCwgdGhlIFA0IGNvbnRpbnVlcyB0byBhc3Nl
cnQgaXRzIE5NSSB1bnRpbCBjbGVhciBieSB0aGUgT1MuCgpBcyBhIHNpZGUgZWZmZWN0IHRvIHRo
aXMgcXVpcmssIHRoZSBOTUkgb24gdGhlIGFwaWMgaXMgbWFza2VkIG9mZiB0byBwcmV2ZW50CmEg
c3RyZWFtIG9mIE5NSXMgdW50aWwgdGhlIG92ZXJmbG93IGZsYWcgaXMgY2xlYXJlZC4gIER1cmlu
ZyB0aGUgcGVyZgpyZS1kZXNpZ24sIHRoaXMgc3VidGxlLW5lc3Mgd2FzIG92ZXJsb29rZWQgYW5k
IHRoZSBhcGljIHdhcyB1bm1hc2tlZCBfYmVmb3JlXwp0aGUgb3ZlcmZsb3cgZmxhZyB3YXMgY2xl
YXJlZC4gIEFzIGEgcmVzdWx0LCB0aGlzIGdlbmVyYXRlZCBhbiBleHRyYSBOTUkgb24KdGhlIFA0
IG1jaGluZXMuCgpUaGUgZml4IGlzIHRyaXZpYWwsIHdhaXQgdW50aWwgdGhlIE5NSSBpcyBwcm9w
ZXJseSBoYW5kbGVkIGJlZm9yZSB1bi1tYXNraW5nCnRoZSBhcGljLgoKU2FkbHksIGluIHRoZSBv
bGQgbm1pIHdhdGNoZG9nIHRoZXJlIHdhcyBhIG5vdGUgdGhhdCBleHBsYWluZWQgdGhpcyBleGFj
dApiZWhhdmlvdXIuCgpTaWduZWQtb2ZmLWJ5OiBEb24gWmlja3VzIDxkemlja3VzQHJlZGhhdC5j
b20+ClRlc3RlZC1ieTogU2hhdW4gUnVmZmVsbCA8c3J1ZmZlbGxAZGlnaXVtLmNvbT4KVGVzdGVk
LWJ5OiBDeXJpbGwgR29yY3Vub3YgPGdvcmN1bm92QG9wZW52ei5vcmc+CkFja2VkLWJ5OiBDeXJp
bGwgR29yY3Vub3YgPGdvcmN1bm92QG9wZW52ei5vcmc+Ci0tLQogYXJjaC94ODYva2VybmVsL2Nw
dS9wZXJmX2V2ZW50LmMgfCAgICAyICstCiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3BlcmZf
ZXZlbnQuYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVudC5jCmluZGV4IGVlZDM2NzNh
Li5lMTA4ZWY4IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3BlcmZfZXZlbnQuYwor
KysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3BlcmZfZXZlbnQuYwpAQCAtMTM3MCw5ICsxMzcwLDkg
QEAgcGVyZl9ldmVudF9ubWlfaGFuZGxlcihzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKnNlbGYsCiAJ
CXJldHVybiBOT1RJRllfRE9ORTsKIAl9CiAKLQlhcGljX3dyaXRlKEFQSUNfTFZUUEMsIEFQSUNf
RE1fTk1JKTsKIAogCWhhbmRsZWQgPSB4ODZfcG11LmhhbmRsZV9pcnEoYXJncy0+cmVncyk7CisJ
YXBpY193cml0ZShBUElDX0xWVFBDLCBBUElDX0RNX05NSSk7CiAJaWYgKCFoYW5kbGVkKQogCQly
ZXR1cm4gTk9USUZZX0RPTkU7CiAKLS0gCjEuNy40LjIKCg==
--001636e0ae486a936204a0c5c44a--
