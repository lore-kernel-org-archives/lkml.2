Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab2I1RJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:09:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36760 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab2I1RJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120928034044.GD13973@ZenIV.linux.org.uk>
References: <20120928034044.GD13973@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Sep 2012 10:08:56 -0700
X-Google-Sender-Auth: 6TFITAVMJ51qR5EYWGqkUcdifMs
Message-ID: <CA+55aFwvkjsXtT31QSSLZgiu9=_51WpHLPN0UQfjUM38q_d4Hw@mail.gmail.com>
Subject: Re: [git pull][vfs.git] a couple of fixes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: multipart/mixed; boundary=e89a8fb201daafaf9704cac61d1f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8fb201daafaf9704cac61d1f
Content-Type: text/plain; charset=ISO-8859-1

Hmm. What is the status of the rename_lock write-lock recursion
deadlock patch from Miklos?

Attached is a simpler version of it (Miklos, can you verify this
simplified version also works for you?), but it's still fairly ugly.

            Linus

--e89a8fb201daafaf9704cac61d1f
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7njqafn0

IGZzL2RjYWNoZS5jIHwgNiArKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykK
CmRpZmYgLS1naXQgYS9mcy9kY2FjaGUuYyBiL2ZzL2RjYWNoZS5jCmluZGV4IDAzNjRhZjIzMTFm
NC4uNjkzZjk1YmYxY2FlIDEwMDY0NAotLS0gYS9mcy9kY2FjaGUuYworKysgYi9mcy9kY2FjaGUu
YwpAQCAtMTEzNCw2ICsxMTM0LDggQEAgcG9zaXRpdmU6CiAJcmV0dXJuIDE7CiAKIHJlbmFtZV9y
ZXRyeToKKwlpZiAobG9ja2VkKQorCQlnb3RvIGFnYWluOwogCWxvY2tlZCA9IDE7CiAJd3JpdGVf
c2VxbG9jaygmcmVuYW1lX2xvY2spOwogCWdvdG8gYWdhaW47CkBAIC0xMjM2LDYgKzEyMzgsOCBA
QCBvdXQ6CiByZW5hbWVfcmV0cnk6CiAJaWYgKGZvdW5kKQogCQlyZXR1cm4gZm91bmQ7CisJaWYg
KGxvY2tlZCkKKwkJZ290byBhZ2FpbjsKIAlsb2NrZWQgPSAxOwogCXdyaXRlX3NlcWxvY2soJnJl
bmFtZV9sb2NrKTsKIAlnb3RvIGFnYWluOwpAQCAtMzAzNSw2ICszMDM5LDggQEAgcmVzdW1lOgog
CXJldHVybjsKIAogcmVuYW1lX3JldHJ5OgorCWlmIChsb2NrZWQpCisJCWdvdG8gYWdhaW47CiAJ
bG9ja2VkID0gMTsKIAl3cml0ZV9zZXFsb2NrKCZyZW5hbWVfbG9jayk7CiAJZ290byBhZ2FpbjsK
--e89a8fb201daafaf9704cac61d1f--
