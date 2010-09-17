Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0IQPgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:36:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44844 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab0IQPgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=D77TQh7HHFc8Nmv5Y0INbe4V3CY1HF26tbONFaiYNUo8ZgyXzMFJFQZ5KrukrwWmY0
         e/2RZ4x+lQ5BB80TggCLtt68Wy1aY1PgnWp5TTUQmu7QkMCY/7DclOKO1JIJNHfubjos
         lskkHHOtTiAT3lnH8l7OvkKlho5ifgbyEw5A8=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 17 Sep 2010 17:36:43 +0200
Message-ID: <AANLkTimeZyZstBR4ZRxJg3OaP_aibLqQtYw2dTJ7cq7c@mail.gmail.com>
Subject: =?UTF-8?B?W2xpbnV4LW5leHRdIGZzL29jZnMyL2ZpbGUuYzoyMDE6IGVycm9yOiDigJhCTEtERVZfSQ==?=
	=?UTF-8?B?RkxfV0FJVOKAmSB1bmRlY2xhcmVkIChmaXJzdCB1c2UgaW4gdGhpcyBmdW5jdGlvbik=?=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk
Content-Type: multipart/mixed; boundary=001636426fdb6eb8c20490765470
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636426fdb6eb8c20490765470
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I pulled linux-2.6-block/for-next into mainline.

The build breaks, the issue is known [1] (but I didnt see a patch):

[ build.log ]
...
/home/sd/src/linux-2.6/linux-2.6.36-rc4/debian/build/source_i386_none/fs/oc=
fs2/file.c:201:
error: =E2=80=98BLKDEV_IFL_WAIT=E2=80=99 undeclared (first use in this func=
tion)
/home/sd/src/linux-2.6/linux-2.6.36-rc4/debian/build/source_i386_none/fs/oc=
fs2/file.c:201:
error: (Each undeclared identifier is reported only once
/home/sd/src/linux-2.6/linux-2.6.36-rc4/debian/build/source_i386_none/fs/oc=
fs2/file.c:201:
error: for each function it appears in.)
/home/sd/src/linux-2.6/linux-2.6.36-rc4/debian/build/source_i386_none/fs/oc=
fs2/file.c:201:
error: too many arguments to function =E2=80=98blkdev_issue_flush=E2=80=99
  CC [M]  net/rxrpc/ar-error.o
  CC [M]  drivers/scsi/scsi_error.o
make[3]: *** [sub-make] Error 2
make[2]: *** [all] Error 2

Regards,
- Sedat -

[1] http://www.spinics.net/lists/linux-next/msg11970.html

P.S.: Is there an email-address for linux-next (did not see in MAINTAINERS)=
?

--001636426fdb6eb8c20490765470
Content-Type: text/plain; charset=US-ASCII; 
	name="ocfs2-Fix-BLKDEV_IFL_WAIT-undeclared-in-blkdev_issue_flush.patch"
Content-Disposition: attachment; 
	filename="ocfs2-Fix-BLKDEV_IFL_WAIT-undeclared-in-blkdev_issue_flush.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ge77jsdh0

SW5kZXg6IGxpbnV4LW5leHQvZnMvb2NmczIvZmlsZS5jCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LW5l
eHQub3JpZy9mcy9vY2ZzMi9maWxlLmMKKysrIGxpbnV4LW5leHQvZnMvb2NmczIvZmlsZS5jCkBA
IC0xOTgsNyArMTk4LDcgQEAgc3RhdGljIGludCBvY2ZzMl9zeW5jX2ZpbGUoc3RydWN0IGZpbGUg
KgogCQkgKi8KIAkJaWYgKG9zYi0+c19tb3VudF9vcHQgJiBPQ0ZTMl9NT1VOVF9CQVJSSUVSKQog
CQkJYmxrZGV2X2lzc3VlX2ZsdXNoKGlub2RlLT5pX3NiLT5zX2JkZXYsIEdGUF9LRVJORUwsCi0J
CQkJCSAgIE5VTEwsIEJMS0RFVl9JRkxfV0FJVCk7CisJCQkJCSAgIE5VTEwpOwogCQlnb3RvIGJh
aWw7CiAJfQogCg==
--001636426fdb6eb8c20490765470--
