Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab1GZEx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 00:53:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750Ab1GZExt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 00:53:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110726033535.GA11939@x4.trippels.de>
References: <20110725185649.GA22133@ZenIV.linux.org.uk> <20110726033535.GA11939@x4.trippels.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Jul 2011 21:52:57 -0700
Message-ID: <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
Subject: Re: [git pull] vfs pile 1.5
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf307f33b2c5b7f704a8f1b539
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf307f33b2c5b7f704a8f1b539
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jul 25, 2011 at 8:35 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> This breaks the build for "# CONFIG_FS_POSIX_ACL is not set" configs:

Of course it does. And as usual, my exhaustive testing was for the
allyesconfig case, rather than doing both allyesconfig and allnoconfig
like I should.

Bah.

Does the attached trivial patch fix everything for you?

                   Linus

--20cf307f33b2c5b7f704a8f1b539
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqke37wn0

IGZzL25hbWVpLmMgfCAgICAyICsrCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9uYW1laS5jIGIvZnMvbmFtZWkuYwppbmRl
eCBlZjAwYjk4NGZiMjAuLmY4YzY5ZDM3Mzc5MyAxMDA2NDQKLS0tIGEvZnMvbmFtZWkuYworKysg
Yi9mcy9uYW1laS5jCkBAIC0xNzYsNiArMTc2LDcgQEAgRVhQT1JUX1NZTUJPTChwdXRuYW1lKTsK
IAogc3RhdGljIGludCBjaGVja19hY2woc3RydWN0IGlub2RlICppbm9kZSwgaW50IG1hc2spCiB7
CisjaWZkZWYgQ09ORklHX0ZTX1BPU0lYX0FDTAogCXN0cnVjdCBwb3NpeF9hY2wgKmFjbDsKIAog
CS8qCkBAIC0yMTksNiArMjIwLDcgQEAgc3RhdGljIGludCBjaGVja19hY2woc3RydWN0IGlub2Rl
ICppbm9kZSwgaW50IG1hc2spCiAJICAgICAgICBwb3NpeF9hY2xfcmVsZWFzZShhY2wpOwogCSAg
ICAgICAgcmV0dXJuIGVycm9yOwogCX0KKyNlbmRpZgogCiAJcmV0dXJuIC1FQUdBSU47CiB9Cg==
--20cf307f33b2c5b7f704a8f1b539--
