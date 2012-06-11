Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2FKF0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:26:05 -0400
Received: from pinky.dpeople.ca ([208.93.239.195]:35758 "EHLO pinky.dpeople.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab2FKF0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:26:04 -0400
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2012 01:26:03 EDT
Date: Mon, 11 Jun 2012 01:07:58 -0400 (EDT)
From: Justin Wheeler <jwheeler@datademons.com>
To: Wim Van Sebroeck <wim@iguana.be>
cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giel van Schijndel <me@mortis.eu>
Subject: Patch for f71808e_wdt.c.
Message-ID: <alpine.DEB.2.00.1206110101290.1027@newbox.vps>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="0-1616516744-1339352620=:1027"
Content-ID: <alpine.DEB.2.00.1206110101300.1027@newbox.vps>
X-SA-Score: -102.9
X-Antivirus-Scanner: Marked clean by ClamAV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1616516744-1339352620=:1027
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Content-ID: <alpine.DEB.2.00.1206110101301.1027@newbox.vps>

Hi,

I have a Jetway JNF99 motherboard, featuring the F71869 SuperIO chip, but its
watchdog chipset ID appears to be 1007 (as opposed to 0814).  Some testing
confirmed it behaves the exact same as 0814.  The short attached patch adds
that chipset ID to the module's ID list so that the Fintek watchdog driver can
correctly identify and access it.

Justin
--0-1616516744-1339352620=:1027
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=f71869a.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.1206101423390.1027@newbox.vps>
Content-Description: 
Content-Disposition: attachment; filename=f71869a.patch

LS0tIGxpbnV4LTMuMi4xMi1nZW50b28ub3JpZy9kcml2ZXJzL3dhdGNoZG9n
L2Y3MTgwOGVfd2R0LmMJMjAxMi0wNi0xMSAwOTo0ODozNS45NDAwMDEwNzYg
LTA0MDANCisrKyBsaW51eC0zLjIuMTItZ2VudG9vL2RyaXZlcnMvd2F0Y2hk
b2cvZjcxODA4ZV93ZHQuYwkyMDEyLTA2LTExIDA5OjQ4OjM1Ljk0MDAwMTA3
NiAtMDQwMA0KQEAgLTU0LDYgKzU0LDcgQEANCiAjZGVmaW5lIFNJT19GNzE4
NThfSUQJCTB4MDUwNwkvKiBDaGlwc2V0IElEICovDQogI2RlZmluZSBTSU9f
RjcxODYyX0lECQkweDA2MDEJLyogQ2hpcHNldCBJRCAqLw0KICNkZWZpbmUg
U0lPX0Y3MTg2OV9JRAkJMHgwODE0CS8qIENoaXBzZXQgSUQgKi8NCisjZGVm
aW5lIFNJT19GNzE4NjlBX0lECQkweDEwMDcJLyogQ2hpcHNldCBJRCAqLw0K
ICNkZWZpbmUgU0lPX0Y3MTg4Ml9JRAkJMHgwNTQxCS8qIENoaXBzZXQgSUQg
Ki8NCiAjZGVmaW5lIFNJT19GNzE4ODlfSUQJCTB4MDcyMwkvKiBDaGlwc2V0
IElEICovDQogDQpAQCAtMTk0LDcgKzE5NSw3IEBADQogCQlyZXR1cm4gLUVC
VVNZOw0KIAl9DQogDQotCS8qIGFjY29yZGluZyB0byB0aGUgZGF0YXNoZWV0
IHRoZSBrZXkgbXVzdCBiZSBzZW5kIHR3aWNlISAqLw0KKwkvKiBhY2NvcmRp
bmcgdG8gdGhlIGRhdGFzaGVldCB0aGUga2V5IG11c3QgYmUgc2VudCB0d2lj
ZSEgKi8NCiAJb3V0YihTSU9fVU5MT0NLX0tFWSwgYmFzZSk7DQogCW91dGIo
U0lPX1VOTE9DS19LRVksIGJhc2UpOw0KIA0KQEAgLTc2MSw2ICs3NjIsNyBA
QA0KIAkJZXJyID0gZjcxODYyZmdfcGluX2NvbmZpZ3VyZSgwKTsgLyogdmFs
aWRhdGUgbW9kdWxlIHBhcmFtZXRlciAqLw0KIAkJYnJlYWs7DQogCWNhc2Ug
U0lPX0Y3MTg2OV9JRDoNCisJY2FzZSBTSU9fRjcxODY5QV9JRDoNCiAJCXdh
dGNoZG9nLnR5cGUgPSBmNzE4Njk7DQogCQlicmVhazsNCiAJY2FzZSBTSU9f
RjcxODgyX0lEOg0K

--0-1616516744-1339352620=:1027--
