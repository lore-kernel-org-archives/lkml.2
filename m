Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2GNC04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 22:26:56 -0400
Received: from nm19-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.216]:29155 "HELO
	nm19-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752832Ab2GNC0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 22:26:54 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 377757.96094.bm@omp1063.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type;
  b=0t/yiEL87VDroVtMGmLxvuHabQij/7IQe4EO/T6ezZul6tld6mtMAkXljuklmjaWM2wu4pFlSUcp11Yb4bndjgBO+EsjUR1GoaHMQX45PmWw8YtzH1XjxSv2eAV5kSTmjSjKcyDz+eRNB55nJ8F7fPXUOQK5oRJ9chIL6NqdSx4=;
X-YMail-OSG: p0WEZjEVM1mahEg7CWWpcm76nrPkkCV7_616yGD25YU7HrT
 vE_QU0ywZH.Ji5J10PgPCoroa2hq9Km2I3o3GogYLoFDmBvJmfCIyd80KgG6
 JqcrLHMqzv6FlAfBkQpCgbDUTH2xR5p5FZvcFtmljXOGr4XY4Unj3Aw7EeIW
 nM3mri5V2lUhnK5UiAAzJzbBa480sQ4WH_H2pUjVcKE4A4LEdmertC1EDnr4
 UfgcOaS2ZiXyIX9iqkBgDxnFrquKijiRMX725cXtFEn7M8ATXw1bkzmhX0kY
 R9oqr0u9l.kA0MW90XLhezAA53HMpl.WigjWm9SRZS_Wujfrh6Eo684A_03p
 eXqX4NA3NYg68P4AcU3Yl0JUQ1CY1IjHebWm5Tt0CAU.ftIFU2VD33WwHPof
 tzVFD6rlpNriNrHFpdqwD3DsC0eD0aXr.x_L.9gOCBY5d9_4-
X-Mailer: YahooMailWebService/0.8.120.356233
Message-ID: <1342232813.26165.YahooMailNeo@web112006.mail.gq1.yahoo.com>
Date: Fri, 13 Jul 2012 19:26:53 -0700 (PDT)
From: Silva Paulo <psdasilva@yahoo.com>
Reply-To: Silva Paulo <psdasilva@yahoo.com>
Subject: Small bug: Wrong return check from idr_pre_get in loop.c
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="557386405-1590733054-1342232813=:26165"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--557386405-1590733054-1342232813=:26165
Content-Type: text/plain; charset=us-ascii

idr_pre_get never returns a value < 0. It returns 0 (no memory) or 1 (OK).

Regards

--557386405-1590733054-1342232813=:26165
Content-Type: application/octet-stream; name="My_linux-3.5-rc6_patches"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="My_linux-3.5-rc6_patches"

LS0tIGxpbnV4LTMuNS1yYzYvZHJpdmVycy9ibG9jay9sb29wLmMub3JpZwky
MDEyLTA3LTA4IDAxOjIzOjU2LjAwMDAwMDAwMCArMDEwMAorKysgbGludXgt
My41LXJjNi9kcml2ZXJzL2Jsb2NrL2xvb3AuYwkyMDEyLTA3LTEzIDE5OjQ1
OjEwLjAwMDAwMDAwMCArMDEwMApAQCAtMTYwMyw5ICsxNjAzLDEwIEBAIHN0
YXRpYyBpbnQgbG9vcF9hZGQoc3RydWN0IGxvb3BfZGV2aWNlICoKIAkJZ290
byBvdXQ7CiAJfQogCi0JZXJyID0gaWRyX3ByZV9nZXQoJmxvb3BfaW5kZXhf
aWRyLCBHRlBfS0VSTkVMKTsKLQlpZiAoZXJyIDwgMCkKKwlpZiAoaWRyX3By
ZV9nZXQoJmxvb3BfaW5kZXhfaWRyLCBHRlBfS0VSTkVMKSA9PSAwKSB7CisJ
CWVyciA9IC1FTk9NRU07CiAJCWdvdG8gb3V0X2ZyZWVfZGV2OworCX0KIAog
CWlmIChpID49IDApIHsKIAkJaW50IG07Cg==

--557386405-1590733054-1342232813=:26165--
