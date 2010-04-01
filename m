Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0DALxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:53:07 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:60785 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab0DALw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:52:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=amfWXMGeKY7XBxHlmEPxqaYgUIx/ycQkbC0uqbPk1h4FA3tVgpwG1W3hbl+vxwlp2F
         lbMJM9TSCyNBqNTGnjHf17ynGs8nQlzGPhJjt6pjwcX7QpAbg/XiK958V6Jin/Viezkq
         8Ml2Wad7Ks6RhLvxqZq0iwqgWfAYdw+SDY1z0=
MIME-Version: 1.0
Date: Thu, 1 Apr 2010 13:52:56 +0200
Message-ID: <z2g40a4ed591004010452u79b931dcw5c195e02021799c@mail.gmail.com>
Subject: kemleaks in 2.6.34-rc3
From: Zeno Davatz <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016364169e7ec391104832b801a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364169e7ec391104832b801a
Content-Type: text/plain; charset=ISO-8859-1

Hi

I am running

Linux zenogentoo 2.6.34-rc3 #86 SMP Wed Mar 31 10:46:51 CEST 2010 i686
Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz GenuineIntel GNU/Linux

and my dmesg is spitting out some kmemleaks. The file is attached from
/sys/kernel/debug/kmemleak

My lspci is:

00:00.0 Host bridge: Intel Corporation X58 I/O Hub to ESI Port (rev 13)
00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 1 (rev 13)
00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 3 (rev 13)
00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 7 (rev 13)
00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management
Registers (rev 13)
00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch
Pad Registers (rev 13)
00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status
and RAS Registers (rev 13)
00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 13)
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
Audio Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 1
00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 2
00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 6
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port
SATA IDE Controller
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port
SATA IDE Controller
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. Device 3403
02:00.1 IDE interface: VIA Technologies, Inc. PATA IDE Host Controller (rev a0)
03:00.0 SATA controller: JMicron Technology Corp. JMicron 20360/20363
AHCI Controller (rev 02)
05:00.0 VGA compatible controller: nVidia Corporation G98 [GeForce
8400 GS] (rev a1)

Let me know if you need anything else.

Best
Zeno

--0016364169e7ec391104832b801a
Content-Type: text/plain; charset=US-ASCII; name="kmemleak.txt"
Content-Disposition: attachment; filename="kmemleak.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g7hi8z8f1

dW5yZWZlcmVuY2VkIG9iamVjdCAweGY2ZDQ5M2MwIChzaXplIDY0KToKICBjb21tICJzd2FwcGVy
IiwgcGlkIDEsIGppZmZpZXMgNDI5NDg5MjYwNCAoYWdlIDk2NjEyLjUyNHMpCiAgaGV4IGR1bXAg
KGZpcnN0IDMyIGJ5dGVzKToKICAgIDAwIDAwIGVlIGM3IDAwIDAwIDAwIDAwIGZmIGI3IGVlIGM3
IDAwIDAwIDAwIDAwICAuLi4uLi4uLi4uLi4uLi4uCiAgICBmNiAxOCA0ZSBjMSAwMCAwMCAwMCA4
MCA4MCA4YSA1YSBjMSBhMCBmOSA2YiBjMSAgLi5OLi4uLi4uLlouLi5rLgogIGJhY2t0cmFjZToK
ICAgIFs8YzE0MjRjZGM+XSBrbWVtbGVha19hbGxvYysweDNhLzB4NTAKICAgIFs8YzEwYWZkZjc+
XSBrbWVtX2NhY2hlX2FsbG9jKzB4YTkvMHhjZgogICAgWzxjMTVmMjQ0Yj5dIF9fcmVzZXJ2ZV9y
ZWdpb25fd2l0aF9zcGxpdCsweDI5LzB4MWRiCiAgICBbPGMxNWYyNTEzPl0gX19yZXNlcnZlX3Jl
Z2lvbl93aXRoX3NwbGl0KzB4ZjEvMHgxZGIKICAgIFs8YzE1ZjI1NDY+XSBfX3Jlc2VydmVfcmVn
aW9uX3dpdGhfc3BsaXQrMHgxMjQvMHgxZGIKICAgIFs8YzE1ZjI1NDY+XSBfX3Jlc2VydmVfcmVn
aW9uX3dpdGhfc3BsaXQrMHgxMjQvMHgxZGIKICAgIFs8YzE1ZjI1NDY+XSBfX3Jlc2VydmVfcmVn
aW9uX3dpdGhfc3BsaXQrMHgxMjQvMHgxZGIKICAgIFs8YzE1ZjI2MzU+XSByZXNlcnZlX3JlZ2lv
bl93aXRoX3NwbGl0KzB4MzgvMHg0YgogICAgWzxjMTVlNGI1Yz5dIGU4MjBfcmVzZXJ2ZV9yZXNv
dXJjZXNfbGF0ZSsweDExOS8weDEyZgogICAgWzxjMTYwODI5Nz5dIHBjaWJpb3NfcmVzb3VyY2Vf
c3VydmV5KzB4MjMvMHgzYwogICAgWzxjMTYwYTE0MT5dIHBjaWJpb3NfaW5pdCsweDQxLzB4N2EK
ICAgIFs8YzE2MDk2ZTU+XSBwY2lfc3Vic3lzX2luaXQrMHhkMy8weGRlCiAgICBbPGMxMDAxMTEw
Pl0gZG9fb25lX2luaXRjYWxsKzB4MjMvMHgxNjkKICAgIFs8YzE1ZTEzNjQ+XSBrZXJuZWxfaW5p
dCsweDEzMy8weDFkNQogICAgWzxjMTAyNTBiNj5dIGtlcm5lbF90aHJlYWRfaGVscGVyKzB4Ni8w
eDEwCiAgICBbPGZmZmZmZmZmPl0gMHhmZmZmZmZmZgp1bnJlZmVyZW5jZWQgb2JqZWN0IDB4ZjZk
ZmI1YzAgKHNpemUgMzIpOgogIGNvbW0gInN3YXBwZXIiLCBwaWQgMSwgamlmZmllcyA0Mjk0ODky
NjE1IChhZ2UgOTY2MTIuNDgwcykKICBoZXggZHVtcCAoZmlyc3QgMzIgYnl0ZXMpOgogICAgNzAg
NmUgNzAgMjAgMzAgMzAgM2EgMzAgMzEgMDAgNjEgNzAgNzAgNjUgNzIgMDAgIHBucCAwMDowMS5h
cHBlci4KICAgIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAxIDAxIDAwIDAwIDAwIDAwIDAwIDAw
ICAuLi4uLi4uLi4uLi4uLi4uCiAgYmFja3RyYWNlOgogICAgWzxjMTQyNGNkYz5dIGttZW1sZWFr
X2FsbG9jKzB4M2EvMHg1MAogICAgWzxjMTBhZmRmNz5dIGttZW1fY2FjaGVfYWxsb2MrMHhhOS8w
eGNmCiAgICBbPGMxMjM2MTZiPl0gcmVzZXJ2ZV9yYW5nZSsweDNiLzB4MTFjCiAgICBbPGMxMjM2
MmQ3Pl0gc3lzdGVtX3BucF9wcm9iZSsweDhiLzB4YzMKICAgIFs8YzEyMzEwNzM+XSBwbnBfZGV2
aWNlX3Byb2JlKzB4NzcvMHhjZQogICAgWzxjMTI5ZDFiNT5dIGRyaXZlcl9wcm9iZV9kZXZpY2Ur
MHg1Yi8weDE0NgogICAgWzxjMTI5ZDMwZD5dIF9fZHJpdmVyX2F0dGFjaCsweDZkLzB4NmYKICAg
IFs8YzEyOWNiYTM+XSBidXNfZm9yX2VhY2hfZGV2KzB4NGUvMHg2YwogICAgWzxjMTI5ZDA5Yj5d
IGRyaXZlcl9hdHRhY2grMHgxOS8weDFiCiAgICBbPGMxMjljNGZjPl0gYnVzX2FkZF9kcml2ZXIr
MHhiYy8weDI1NgogICAgWzxjMTI5ZDUzYT5dIGRyaXZlcl9yZWdpc3RlcisweDc1LzB4MTQzCiAg
ICBbPGMxMjMwZTlmPl0gcG5wX3JlZ2lzdGVyX2RyaXZlcisweDE3LzB4MTkKICAgIFs8YzE1ZmY2
MTI+XSBwbnBfc3lzdGVtX2luaXQrMHhkLzB4MWIKICAgIFs8YzEwMDExMTA+XSBkb19vbmVfaW5p
dGNhbGwrMHgyMy8weDE2OQogICAgWzxjMTVlMTM2ND5dIGtlcm5lbF9pbml0KzB4MTMzLzB4MWQ1
CiAgICBbPGMxMDI1MGI2Pl0ga2VybmVsX3RocmVhZF9oZWxwZXIrMHg2LzB4MTAKdW5yZWZlcmVu
Y2VkIG9iamVjdCAweGY2ZDJjYmMwIChzaXplIDY0KToKICBjb21tICJzd2FwcGVyIiwgcGlkIDEs
IGppZmZpZXMgNDI5NDg5MjYxNSAoYWdlIDk2NjEyLjQ4MHMpCiAgaGV4IGR1bXAgKGZpcnN0IDMy
IGJ5dGVzKToKICAgIDAwIGEwIGM4IGZlIDAwIDAwIDAwIDAwIGZmIGFmIGM4IGZlIDAwIDAwIDAw
IDAwICAuLi4uLi4uLi4uLi4uLi4uCiAgICBjMCBiNSBkZiBmNiAwMCAwMCAwMCAwMCA3NCA0OSA3
ZSBmNyA4MCBjYiBkMiBmNiAgLi4uLi4uLi50SX4uLi4uLgogIGJhY2t0cmFjZToKICAgIFs8YzE0
MjRjZGM+XSBrbWVtbGVha19hbGxvYysweDNhLzB4NTAKICAgIFs8YzEwYWZkZjc+XSBrbWVtX2Nh
Y2hlX2FsbG9jKzB4YTkvMHhjZgogICAgWzxjMTA1ODdmMj5dIF9fcmVxdWVzdF9yZWdpb24rMHgx
ZS8weDFiMQogICAgWzxjMTIzNjIzYz5dIHJlc2VydmVfcmFuZ2UrMHgxMGMvMHgxMWMKICAgIFs8
YzEyMzYyZDc+XSBzeXN0ZW1fcG5wX3Byb2JlKzB4OGIvMHhjMwogICAgWzxjMTIzMTA3Mz5dIHBu
cF9kZXZpY2VfcHJvYmUrMHg3Ny8weGNlCiAgICBbPGMxMjlkMWI1Pl0gZHJpdmVyX3Byb2JlX2Rl
dmljZSsweDViLzB4MTQ2CiAgICBbPGMxMjlkMzBkPl0gX19kcml2ZXJfYXR0YWNoKzB4NmQvMHg2
ZgogICAgWzxjMTI5Y2JhMz5dIGJ1c19mb3JfZWFjaF9kZXYrMHg0ZS8weDZjCiAgICBbPGMxMjlk
MDliPl0gZHJpdmVyX2F0dGFjaCsweDE5LzB4MWIKICAgIFs8YzEyOWM0ZmM+XSBidXNfYWRkX2Ry
aXZlcisweGJjLzB4MjU2CiAgICBbPGMxMjlkNTNhPl0gZHJpdmVyX3JlZ2lzdGVyKzB4NzUvMHgx
NDMKICAgIFs8YzEyMzBlOWY+XSBwbnBfcmVnaXN0ZXJfZHJpdmVyKzB4MTcvMHgxOQogICAgWzxj
MTVmZjYxMj5dIHBucF9zeXN0ZW1faW5pdCsweGQvMHgxYgogICAgWzxjMTAwMTExMD5dIGRvX29u
ZV9pbml0Y2FsbCsweDIzLzB4MTY5CiAgICBbPGMxNWUxMzY0Pl0ga2VybmVsX2luaXQrMHgxMzMv
MHgxZDUKdW5yZWZlcmVuY2VkIG9iamVjdCAweGY2ZGZiNWEwIChzaXplIDMyKToKICBjb21tICJz
d2FwcGVyIiwgcGlkIDEsIGppZmZpZXMgNDI5NDg5MjYxNSAoYWdlIDk2NjEyLjQ4MHMpCiAgaGV4
IGR1bXAgKGZpcnN0IDMyIGJ5dGVzKToKICAgIDcwIDZlIDcwIDIwIDMwIDMwIDNhIDMwIDMxIDAw
IDIyIGMxIDcwIDRhIDIyIGMxICBwbnAgMDA6MDEuIi5wSiIuCiAgICBmMiBkMyAyMSBjMSBiMyBm
MCAyMSBjMSBmMyBkMiAyMSBjMSAxMCAwMCAwMCAwMCAgLi4hLi4uIS4uLiEuLi4uLgogIGJhY2t0
cmFjZToKICAgIFs8YzE0MjRjZGM+XSBrbWVtbGVha19hbGxvYysweDNhLzB4NTAKICAgIFs8YzEw
YWZkZjc+XSBrbWVtX2NhY2hlX2FsbG9jKzB4YTkvMHhjZgogICAgWzxjMTIzNjE2Yj5dIHJlc2Vy
dmVfcmFuZ2UrMHgzYi8weDExYwogICAgWzxjMTIzNjJkNz5dIHN5c3RlbV9wbnBfcHJvYmUrMHg4
Yi8weGMzCiAgICBbPGMxMjMxMDczPl0gcG5wX2RldmljZV9wcm9iZSsweDc3LzB4Y2UKICAgIFs8
YzEyOWQxYjU+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4NWIvMHgxNDYKICAgIFs8YzEyOWQzMGQ+
XSBfX2RyaXZlcl9hdHRhY2grMHg2ZC8weDZmCiAgICBbPGMxMjljYmEzPl0gYnVzX2Zvcl9lYWNo
X2RldisweDRlLzB4NmMKICAgIFs8YzEyOWQwOWI+XSBkcml2ZXJfYXR0YWNoKzB4MTkvMHgxYgog
ICAgWzxjMTI5YzRmYz5dIGJ1c19hZGRfZHJpdmVyKzB4YmMvMHgyNTYKICAgIFs8YzEyOWQ1M2E+
XSBkcml2ZXJfcmVnaXN0ZXIrMHg3NS8weDE0MwogICAgWzxjMTIzMGU5Zj5dIHBucF9yZWdpc3Rl
cl9kcml2ZXIrMHgxNy8weDE5CiAgICBbPGMxNWZmNjEyPl0gcG5wX3N5c3RlbV9pbml0KzB4ZC8w
eDFiCiAgICBbPGMxMDAxMTEwPl0gZG9fb25lX2luaXRjYWxsKzB4MjMvMHgxNjkKICAgIFs8YzE1
ZTEzNjQ+XSBrZXJuZWxfaW5pdCsweDEzMy8weDFkNQogICAgWzxjMTAyNTBiNj5dIGtlcm5lbF90
aHJlYWRfaGVscGVyKzB4Ni8weDEwCg==
--0016364169e7ec391104832b801a--
