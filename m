Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1GQJiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:38:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44550 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1GQJiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:38:19 -0400
MIME-Version: 1.0
Date: Sun, 17 Jul 2011 17:38:18 +0800
Message-ID: <CAM_iQpV0jNmb7MCW4fFpwhCQ=YNefBZwdemHH4cFjUVVsHb-fA@mail.gmail.com>
Subject: [Patch] xtensa: fix a build error in arch/xtensa/include/asm/uaccess.h
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Zankel <chris@zankel.net>
Content-Type: multipart/mixed; boundary=0050450144bc8d98bb04a840a455
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0050450144bc8d98bb04a840a455
Content-Type: text/plain; charset=UTF-8

This patch fixes the following build error,


src/arch/xtensa/include/asm/uaccess.h:403: error: implicit declaration
of function 'prefetch': 1 errors in 1 logs
        v3.0-rc6/xtensa/xtensa-defconfig
src/arch/xtensa/include/asm/uaccess.h:412: error: implicit declaration
of function 'prefetchw': 1 errors in 1 logs
        v3.0-rc6/xtensa/xtensa-defconfig

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Chris Zankel <chris@zankel.net>

---

--0050450144bc8d98bb04a840a455
Content-Type: text/x-patch; charset=US-ASCII; name="xtensa-include-prefetch_h.diff"
Content-Disposition: attachment; filename="xtensa-include-prefetch_h.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gq7tbm360

ZGlmZiAtLWdpdCBhL2FyY2gveHRlbnNhL2luY2x1ZGUvYXNtL3VhY2Nlc3MuaCBiL2FyY2gveHRl
bnNhL2luY2x1ZGUvYXNtL3VhY2Nlc3MuaAppbmRleCA1YjBjMThjLi5jMTQxYjExIDEwMDY0NAot
LS0gYS9hcmNoL3h0ZW5zYS9pbmNsdWRlL2FzbS91YWNjZXNzLmgKKysrIGIvYXJjaC94dGVuc2Ev
aW5jbHVkZS9hc20vdWFjY2Vzcy5oCkBAIC0xNyw2ICsxNyw3IEBACiAjZGVmaW5lIF9YVEVOU0Ff
VUFDQ0VTU19ICiAKICNpbmNsdWRlIDxsaW51eC9lcnJuby5oPgorI2luY2x1ZGUgPGxpbnV4L3By
ZWZldGNoLmg+CiAKICNkZWZpbmUgVkVSSUZZX1JFQUQgICAgMAogI2RlZmluZSBWRVJJRllfV1JJ
VEUgICAxCg==
--0050450144bc8d98bb04a840a455--
