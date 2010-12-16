Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0LPBLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 20:11:25 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46271 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0LPBLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 20:11:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tyoHtNMnW8HHExmpMpKu5xMIVKqxRN+Ktu/kFAQiv5uybk8dIKj70FMWdrXWA+JXWu
         N6JNckj00PUUYGML3jhYPQ4RijIMrfbXa98K8cbyB6yvAXVCnmEI0wxqPb7y2f3ysvo3
         zE8mMR4cmnTIebFVkDY+/mFNK3q4drDWp/bmo=
MIME-Version: 1.0
Date: Wed, 15 Dec 2010 17:11:22 -0800
Message-ID: <AANLkTik90p-L+4_GnwXzoekCK0E2uemZD6tOK_kEFd2n@mail.gmail.com>
Subject: PATCH: Put .zdebug* section on white list
From: "H.J. Lu" <hjl.tools@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: multipart/mixed; boundary=90e6ba53aa4e6db3d204977cbb7e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba53aa4e6db3d204977cbb7e
Content-Type: text/plain; charset=ISO-8859-1

Hi,

"as --compress-debug-sections" will generate compressed debug sections
with section names ".zdebug*".  This patch puts .zdebug* section on
white list.


-- 
H.J.

--90e6ba53aa4e6db3d204977cbb7e
Content-Type: text/plain; charset=US-ASCII; name="zdebug.patch"
Content-Disposition: attachment; filename="zdebug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghqyem580

ZGlmZiAtLWdpdCBhL3NjcmlwdHMvbW9kL21vZHBvc3QuYyBiL3NjcmlwdHMvbW9kL21vZHBvc3Qu
YwppbmRleCA2YTA4N2ZmLi4yYmFiNjIyIDEwMDY0NAotLS0gYS9zY3JpcHRzL21vZC9tb2Rwb3N0
LmMKKysrIGIvc2NyaXB0cy9tb2QvbW9kcG9zdC5jCkBAIC03OTAsNiArNzkwLDcgQEAgc3RhdGlj
IGNvbnN0IGNoYXIgKnNlY3Rpb25fd2hpdGVfbGlzdFtdID0KIHsKIAkiLmNvbW1lbnQqIiwKIAki
LmRlYnVnKiIsCisJIi56ZGVidWcqIiwJCS8qIENvbXByZXNzZWQgZGVidWcgc2VjdGlvbnMuICov
CiAJIi5HQ0MtY29tbWFuZC1saW5lIiwJLyogbW4xMDMwMCAqLwogCSIubWRlYnVnKiIsICAgICAg
ICAvKiBhbHBoYSwgc2NvcmUsIG1pcHMgZXRjLiAqLwogCSIucGRyIiwgICAgICAgICAgICAvKiBh
bHBoYSwgc2NvcmUsIG1pcHMgZXRjLiAqLwo=
--90e6ba53aa4e6db3d204977cbb7e--
