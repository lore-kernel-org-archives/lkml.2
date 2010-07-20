Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0GTHKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:10:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44347 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab0GTHKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iafiXPdejJ+QNQP5D17rxjfkBK1o3naA/d9qYIgVS71QBlY5sBCKsnCrmHWkVm/d8J
         txhwzUrDdhXDIMr6h/kWqWGtdmYwwwsbW1Bj4yuuu5IRYBJ5ObTTRh/rkWEw4zU990T9
         SOQy1P4IavnTuA2/pO+klAONtIQfKExF5DivQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTim3VQ7afK91Opco06jzHJ35hHfn13heiXUp7YJ2@mail.gmail.com>
References: <AANLkTim3VQ7afK91Opco06jzHJ35hHfn13heiXUp7YJ2@mail.gmail.com>
Date: Tue, 20 Jul 2010 03:09:59 -0400
Message-ID: <AANLkTimAUG9DZpCyFBgf_XV9asj7ClBe2Lrjkh8tM0ll@mail.gmail.com>
Subject: Re: Blank (disconnected) screen during boot with latest 2.6.35-rcX 
	kernels
From: Alex Deucher <alexdeucher@gmail.com>
To: trapdoor6@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, xorg-driver-ati@lists.x.org,
        trapDoor <trapdoor6@googlemail.com>
Content-Type: multipart/mixed; boundary=0016364eded295f320048bcc5fcf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364eded295f320048bcc5fcf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 19, 2010 at 5:50 PM, trapDoor <trapdoor6@gmail.com> wrote:
> Dear kernel Developers,
> I'd like to report a bug occurring on my machine with some of the
> latest 2.6.35-rcX and the '-next' kernels. As I'm not sure what is the
> problem related to I may have omitted relevant people among the
> recipients. If it is so I'll be thankful if someone could cc them.
> Also I must apologise for reporting this so late, when it's close to
> the end of development cycle for 2.6.35.
>
> I didn't try to bisect. I've never done it before and maybe someone
> will able to reproduce the problem or see straight what's going on by
> looking into attached log/config files. But if it is necessary I'll
> try my hand at bisecting.
>
> ******
> Description of the problem:
>
> Affected kernels tested by me: 2.6.35-rc5-git3, 2.6.35-rc4-git5 and
> 2.6.35-rc4-next-20100712.
> Kernel 2.6.34.1 works OK.
>
> Briefly what happens is that my graphics card seems to loose
> connection with the LCD screen (connected through DVI) during boot.
> Initially it does show something - a blank screen with blinking cursor
> but it lasts only for about 2-3 seconds and then the screen switches
> to stand-by mode giving message 'No signal detected !'. The booting
> process seems to continue though, and looking cursorily through
> related dmesg and Xorg logs I can't see any suspicious messages
> (comparing with the same logs produced when booting from working
> kernel). I'm attaching the following files with this e-mail:
> =A0 =A0dmesg, Xorg.0.log - produced during successful boot with 2.6.34.1
> =A0 =A0dmesg.0, Xorg.0.log.old - these are for the failed boot with 2.6.3=
5-rc5-git3
>
> Also please find attached config files:
> =A0=A0=A0 config-2.6.34.1 - for my current, working kernel
> =A0=A0=A0 config-2.6.35-rc5-git3 - based on above, almost all new entries=
 I
> left undefined/disabled during making 'oldconfig'; particularly I
> didn't touch any options related to PCI, graphics drivers, ACPI or
> power management - these should be all the same as in config-2.6.34.1
>
> All the kernels were compiled on the same PC and system, they have/had
> radeon-kms enabled by default and these firmware files compiled in:
> R600_rlc.bin, R700_rlc.bin
>
> ******
> A brief specification of my system:
>
> 1) OS/software:
>
> Ubuntu 10.04, amd64
>
> Xorg, xserver, drm, mesa, drm and ati/radeon drivers installed from
> the following Ubuntu PPA repository:
> https://edge.launchpad.net/~xorg-edgers/+archive/ppa/
>
> Current versions:
> xorg:=A0 1:7.5+6ubuntu1~xorgedgers3~lucid
> xserver:=A0 2:1.8.2+git20100705+server-1.8-branch.665aa7ce-0ubuntu0sarvat=
t2~lucid
> xserver-xorg-video-ati:=A0 1:6.13.99+git20100716.cdeb1949-0ubuntu0sarvatt=
~lucid
> xserver-xorg-video-radeon:=A0 1:6.13.99+git20100716.cdeb1949-0ubuntu0sarv=
att~lucid
> drm:=A0 1:2.4.20+git20100513.a3305b07-0ubuntu0sarvatt~lucid
> mesa:=A0 7.9.0+git20100718.4eaf591d-0ubuntu0sarvatt~lucid
>
> 2) Hardvare:
> MB: Asus M4A79T Deluxe with chipsets AMD 790FX/SB750
> Processor: AMD Phenom II X4 810
> Graphics Card: Asus EAH3650 SILENT/HTDI/512M - based on chipset RV635
> PRO, port PCIEx2, connected with LCD through DVI
>
> ******
> Please let me know if anyone requires additional details and if there
> is any tracking/testing I could do on my end.

The driver is not able to detect any attached monitors with 2.6.35:

[    1.980334] No connectors reported connected with modes
[    1.980338] [drm] Cannot find any crtc or sizes - going 1024x768

[    19.012] (II) RADEON(0): Output HDMI-0 disconnected
[    19.012] (II) RADEON(0): Output VGA-0 disconnected
[    19.012] (II) RADEON(0): Output DIN disconnected
[    19.012] (II) RADEON(0): Output DVI-0 disconnected
[    19.012] (WW) RADEON(0): Unable to find connected outputs -
setting 1024x768 initial framebuffer

I think the attached patch should fix the issue.  if not, can you try
reverting b2ea4aa67bfd084834edd070e0a4a47857d6db59 ?

Alex

--0016364eded295f320048bcc5fcf
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-fix-shared-ddc-harder.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-fix-shared-ddc-harder.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbuel1ib6

RnJvbSA1ZDBhMjM2OThmNTdmNDg4NTMyZWUwNDg5Zjg5MzFlZTc5ZDZlYTNmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogVHVlLCAyMCBKdWwgMjAxMCAwMzowMToxNCAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBmaXggc2hhcmVkIGRkYyBoYXJkZXIKClRoaXMgZml4ZXMgYSByZWdyZXNz
aW9uIGNhdXNlZCBieSBiMmVhNGFhNjdiZmQwODQ4MzRlZGQwNzBlMGE0YTQ3ODU3ZDZkYjU5CmR1
ZSB0byB0aGUgd2F5IHNoYXJlZCBkZGMgd2l0aCBtdWx0aXBsZSBkaWdpdGFsIGNvbm5lY3RvcnMg
d2FzIGhhbmRsZWQuCgpZb3UgZ2VuZXJhbGx5IGhhdmUgdHdvIGNhc2VzIHdoZXJlIEREQyBsaW5l
cyBhcmUgc2hhcmVkOgotIEhETUkgKyBWR0EKLSBIRE1JICsgRFZJLUQKCkhETUkgKyBWR0EgaXMg
ZWFzeSB0byBkZWFsIHdpdGggYmVjYXVzZSB5b3UgY2FuIGNoZWNrIHRoZSBFRElEIGZvciB0aGUK
dG8gc2VlIGlmIHRoZSBhdHRhY2hlZCBtb25pdG9yIGlzIGRpZ2l0YWwuICBBIHNoYXJlZCBEREMg
bGluZSB3aXRoIHR3bwpkaWdpdGFsIGNvbm5lY3RvcnMgaXMgbW9yZSBjb21wbGV4LiAgWW91IGNh
bid0IHVzZSB0aGUgaGRtaSBiaXRzIGluIHRoZQpFRElEIHNpbmNlIHRoZXkgbWF5IG5vdCBiZSB0
aGVyZSB3aXRoIERWSTwtPkhETUkgYWRhcHRlcnMuICBJbiB0aGlzIGNhc2UKYWxsIHdlIGNhbiBk
byBpcyBjaGVjayB0aGUgSFBEIHBpbnMgdG8gc2VlIHdoaWNoIGlzIGNvbm5lY3RlZCBhcyB3ZSBo
YXZlCm5vIHdheSBvZiBrbm93aW5nIHVzaW5nIHRoZSBFRElELgoKUmVwb3J0ZWQtYnk6IHRyYXBk
b29yNkBnbWFpbC5jb20KU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4ZGV1Y2hlckBn
bWFpbC5jb20+CkNjOiBzdGFibGVAa2VybmVsLm9yZwotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRl
b24vcmFkZW9uX2Nvbm5lY3RvcnMuYyB8ICAgMjMgKysrKysrKysrLS0tLS0tLS0tLS0tLS0KIDEg
ZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9jb25uZWN0b3JzLmMgYi9kcml2ZXJz
L2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9jb25uZWN0b3JzLmMKaW5kZXggZjU4ZjhiZC4uYWRjY2Jj
MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fY29ubmVjdG9ycy5j
CisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Nvbm5lY3RvcnMuYwpAQCAtNzcx
LDE0ICs3NzEsMTQgQEAgc3RhdGljIGVudW0gZHJtX2Nvbm5lY3Rvcl9zdGF0dXMgcmFkZW9uX2R2
aV9kZXRlY3Qoc3RydWN0IGRybV9jb25uZWN0b3IgKmNvbm5lY3QKIAkJCX0gZWxzZQogCQkJCXJl
dCA9IGNvbm5lY3Rvcl9zdGF0dXNfY29ubmVjdGVkOwogCi0JCQkvKiBtdWx0aXBsZSBjb25uZWN0
b3JzIG9uIHRoZSBzYW1lIGVuY29kZXIgd2l0aCB0aGUgc2FtZSBkZGMgbGluZQotCQkJICogVGhp
cyB0ZW5kcyB0byBiZSBIRE1JIGFuZCBEVkkgb24gdGhlIHNhbWUgZW5jb2RlciB3aXRoIHRoZQot
CQkJICogc2FtZSBkZGMgbGluZS4gIElmIHRoZSBlZGlkIHNheXMgSERNSSwgY29uc2lkZXIgdGhl
IEhETUkgcG9ydAotCQkJICogY29ubmVjdGVkIGFuZCB0aGUgRFZJIHBvcnQgZGlzY29ubmVjdGVk
LiAgSWYgdGhlIGVkaWQgZG9lc24ndAotCQkJICogc2F5IEhETUksIHZpY2UgdmVyc2EuCisJCQkv
KiBUaGlzIGdldHMgY29tcGxpY2F0ZWQuICBXZSBoYXZlIGJvYXJkcyB3aXRoIFZHQSArIEhETUkg
d2l0aCBhCisJCQkgKiBzaGFyZWQgRERDIGxpbmUgYW5kIHdlIGhhdmUgYm9hcmRzIHdpdGggRFZJ
LUQgKyBIRE1JIHdpdGggYSBzaGFyZWQKKwkJCSAqIEREQyBsaW5lLiAgVGhlIGxhdHRlciBpcyBt
b3JlIGNvbXBsZXggYmVjYXVzZSB3aXRoIERWSTwtPkhETUkgYWRhcHRlcnMKKwkJCSAqIHlvdSBk
b24ndCByZWFsbHkga25vdyB3aGF0J3MgY29ubmVjdGVkIHRvIHdoaWNoIHBvcnQgYXMgYm90aCBh
cmUgZGlnaXRhbC4KIAkJCSAqLwogCQkJaWYgKHJhZGVvbl9jb25uZWN0b3ItPnNoYXJlZF9kZGMg
JiYgKHJldCA9PSBjb25uZWN0b3Jfc3RhdHVzX2Nvbm5lY3RlZCkpIHsKIAkJCQlzdHJ1Y3QgZHJt
X2RldmljZSAqZGV2ID0gY29ubmVjdG9yLT5kZXY7CisJCQkJc3RydWN0IHJhZGVvbl9kZXZpY2Ug
KnJkZXYgPSBkZXYtPmRldl9wcml2YXRlOwogCQkJCXN0cnVjdCBkcm1fY29ubmVjdG9yICpsaXN0
X2Nvbm5lY3RvcjsKIAkJCQlzdHJ1Y3QgcmFkZW9uX2Nvbm5lY3RvciAqbGlzdF9yYWRlb25fY29u
bmVjdG9yOwogCQkJCWxpc3RfZm9yX2VhY2hfZW50cnkobGlzdF9jb25uZWN0b3IsICZkZXYtPm1v
ZGVfY29uZmlnLmNvbm5lY3Rvcl9saXN0LCBoZWFkKSB7CkBAIC03ODgsMTUgKzc4OCwxMCBAQCBz
dGF0aWMgZW51bSBkcm1fY29ubmVjdG9yX3N0YXR1cyByYWRlb25fZHZpX2RldGVjdChzdHJ1Y3Qg
ZHJtX2Nvbm5lY3RvciAqY29ubmVjdAogCQkJCQlpZiAobGlzdF9yYWRlb25fY29ubmVjdG9yLT5z
aGFyZWRfZGRjICYmCiAJCQkJCSAgICAobGlzdF9yYWRlb25fY29ubmVjdG9yLT5kZGNfYnVzLT5y
ZWMuaTJjX2lkID09CiAJCQkJCSAgICAgcmFkZW9uX2Nvbm5lY3Rvci0+ZGRjX2J1cy0+cmVjLmky
Y19pZCkpIHsKLQkJCQkJCWlmIChkcm1fZGV0ZWN0X2hkbWlfbW9uaXRvcihyYWRlb25fY29ubmVj
dG9yLT5lZGlkKSkgewotCQkJCQkJCWlmIChjb25uZWN0b3ItPmNvbm5lY3Rvcl90eXBlID09IERS
TV9NT0RFX0NPTk5FQ1RPUl9EVklEKSB7Ci0JCQkJCQkJCWtmcmVlKHJhZGVvbl9jb25uZWN0b3It
PmVkaWQpOwotCQkJCQkJCQlyYWRlb25fY29ubmVjdG9yLT5lZGlkID0gTlVMTDsKLQkJCQkJCQkJ
cmV0ID0gY29ubmVjdG9yX3N0YXR1c19kaXNjb25uZWN0ZWQ7Ci0JCQkJCQkJfQotCQkJCQkJfSBl
bHNlIHsKLQkJCQkJCQlpZiAoKGNvbm5lY3Rvci0+Y29ubmVjdG9yX3R5cGUgPT0gRFJNX01PREVf
Q09OTkVDVE9SX0hETUlBKSB8fAotCQkJCQkJCSAgICAoY29ubmVjdG9yLT5jb25uZWN0b3JfdHlw
ZSA9PSBEUk1fTU9ERV9DT05ORUNUT1JfSERNSUIpKSB7CisJCQkJCQkvKiBjYXNlcyB3aGVyZSBi
b3RoIGNvbm5lY3RvcnMgYXJlIGRpZ2l0YWwgKi8KKwkJCQkJCWlmIChsaXN0X2Nvbm5lY3Rvci0+
Y29ubmVjdG9yX3R5cGUgIT0gRFJNX01PREVfQ09OTkVDVE9SX1ZHQSkgeworCQkJCQkJCS8qIGhw
ZCBpcyBvdXIgb25seSBvcHRpb24gaW4gdGhpcyBjYXNlICovCisJCQkJCQkJaWYgKCFyYWRlb25f
aHBkX3NlbnNlKHJkZXYsIHJhZGVvbl9jb25uZWN0b3ItPmhwZC5ocGQpKSB7CiAJCQkJCQkJCWtm
cmVlKHJhZGVvbl9jb25uZWN0b3ItPmVkaWQpOwogCQkJCQkJCQlyYWRlb25fY29ubmVjdG9yLT5l
ZGlkID0gTlVMTDsKIAkJCQkJCQkJcmV0ID0gY29ubmVjdG9yX3N0YXR1c19kaXNjb25uZWN0ZWQ7
Ci0tIAoxLjcuMS4xCgo=
--0016364eded295f320048bcc5fcf--
