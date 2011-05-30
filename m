Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab1E3R7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:59:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33664 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1E3R7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=I+se9Zaf0elbvP7gwemXtQMd3GQjfGLOYcLi2vNw747nfSwDq/f1ZX5+GthrpASglY
         kfJslVjmvnR86tDCLKlA8Lyva9LmBWPtWWKSHKfx7zF5n1ymeLbjbUXazekZWCFF8Aa5
         1qFVVi2HUP5J38S0KTJSmx/s72VmKLO6oXKj8=
MIME-Version: 1.0
In-Reply-To: <11791.1306777203@turing-police.cc.vt.edu>
References: <rohityadav89@gmail.com> <1306776629-13404-1-git-send-email-rohityadav89@gmail.com>
 <11791.1306777203@turing-police.cc.vt.edu>
From: Rohit Yadav <rohityadav89@gmail.com>
Date: Mon, 30 May 2011 23:28:47 +0530
Message-ID: <BANLkTim2yJkQG=2JzFwxcAUfB3HF_m52Rg@mail.gmail.com>
Subject: Re: [PATCH] Arch: x86: process: Fix a compilation warning.
To: Valdis.Kletnieks@vt.edu
Cc: len.brown@intel.com, trenn@suse.de, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00151748e70c2efdaa04a4820b8a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151748e70c2efdaa04a4820b8a
Content-Type: text/plain; charset=ISO-8859-1

> I think what was *intended* was:
>
> WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\n");

Sure, anyway it was just an exercise, writing and submitting my first
Linux kernel patch.
Attached: New patch.

--00151748e70c2efdaa04a4820b8a
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-Arch-x86-process-Fix-a-compilation-warning.patch"
Content-Disposition: attachment; 
	filename="0001-Arch-x86-process-Fix-a-compilation-warning.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gobq007k1

RnJvbSBhYjQ5M2IyYWYxZDZmZTY3OTJiMjFmZTAxNjA4YWMyMjc3Y2M3OWU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdCBZYWRhdiA8cm9oaXR5YWRhdjg5QGdtYWlsLmNvbT4K
RGF0ZTogTW9uLCAzMCBNYXkgMjAxMSAyMjoxNjo1NCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIEFy
Y2g6IHg4NjogcHJvY2VzczogRml4IGEgY29tcGlsYXRpb24gd2FybmluZy4KClJlbW92ZSB1bmtu
b3duIGVzY2FwZSBzZXF1ZW5jZSBcaSBpbiBpZGxlX3NldHVwLgoKU2lnbmVkLW9mZi1ieTogUm9o
aXQgWWFkYXYgPHJvaGl0eWFkYXY4OUBnbWFpbC5jb20+Ci0tLQogYXJjaC94ODYva2VybmVsL3By
b2Nlc3MuYyB8ICAgIDIgKy0KIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9wcm9jZXNzLmMgYi9hcmNo
L3g4Ni9rZXJuZWwvcHJvY2Vzcy5jCmluZGV4IDQyNmE1YjYuLmVkMmRhMjkgMTAwNjQ0Ci0tLSBh
L2FyY2gveDg2L2tlcm5lbC9wcm9jZXNzLmMKKysrIGIvYXJjaC94ODYva2VybmVsL3Byb2Nlc3Mu
YwpAQCAtNjQyLDcgKzY0Miw3IEBAIHN0YXRpYyBpbnQgX19pbml0IGlkbGVfc2V0dXAoY2hhciAq
c3RyKQogCQlib290X29wdGlvbl9pZGxlX292ZXJyaWRlID0gSURMRV9QT0xMOwogCX0gZWxzZSBp
ZiAoIXN0cmNtcChzdHIsICJtd2FpdCIpKSB7CiAJCWJvb3Rfb3B0aW9uX2lkbGVfb3ZlcnJpZGUg
PSBJRExFX0ZPUkNFX01XQUlUOwotCQlXQVJOX09OQ0UoMSwgIlxpZGxlPW13YWl0XCIgd2lsbCBi
ZSByZW1vdmVkIGluIDIwMTJcIlxuIik7CisJCVdBUk5fT05DRSgxLCAiXCJpZGxlPW13YWl0XCIg
d2lsbCBiZSByZW1vdmVkIGluIDIwMTIuXG4iKTsKIAl9IGVsc2UgaWYgKCFzdHJjbXAoc3RyLCAi
aGFsdCIpKSB7CiAJCS8qCiAJCSAqIFdoZW4gdGhlIGJvb3Qgb3B0aW9uIG9mIGlkbGU9aGFsdCBp
cyBhZGRlZCwgaGFsdCBpcwotLSAKMS43LjQuMQoK
--00151748e70c2efdaa04a4820b8a--
