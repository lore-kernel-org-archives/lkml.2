Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2DTTZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:25:06 -0400
Received: from mail.df.lth.se ([194.47.250.12]:16217 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab2DTTZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:25:04 -0400
From: "Linus Walleij" <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [GIT PULL] pinctrl fixes for v3.4
Date: Fri, 20 Apr 2012 21:24:42 +0200
Message-Id: <1334949882-5617-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

Here is a signed tag of the latest pin control fixes.

- - Fixed compilation errors and warnings
- - Stricter checks on the ops vtable

Not much, still something.

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git for-torvalds-20120418

Dong Aisheng (1):
      pinctrl: fix compile error if not select PINMUX support

Stephen Warren (2):
      pinctrl: include <linux/bug.h> to prevent compile errors
      pinctrl: implement pinctrl_check_ops

 drivers/pinctrl/core.c          |   25 +++++++++++++++++++++----
 include/linux/pinctrl/machine.h |    4 +++-
 2 files changed, 24 insertions(+), 5 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkbdQAAoJEEEQszewGV1zyd8P/3BYsv8yjt/rJh41DMtD1GE+
smk4KY986oC0y/q/0H/OFFlbcVm7qCcojDY2X25q7G1ct4fQYUG3GqACk+EMfpl5
JX9wkI1ABYL1vpYO+SPELMUMcu1LKB6CHukPy2Fz/oMyKZX50AyTr+hkvtpUkEZx
tn7ldfloDOIPDS6a/ryUtNma6NM3qsFc26Z+20uypMJz4NMrPbEE71PObmMHhfnH
cXuztL2a4h1jwO/y8sNVUM19ZZwxw/gLfbMnWAUeww0zj4pEcvLyvzy4IWW4KmVC
nzJ5XvBw+mlymcvJBB2XaM/xqkpOFkUfBDx4CrnpewMdRzHTGxmeGecKB8UI+Yar
yfz5DxwhaJGquRKp2m/JFPyHxRRU+TE2R7dxUbSaQ0zmdxv6+LukNNVSmgcZbjm9
kHlB4nRWRXX4KOpMbFvUqmF0YIs2Cc7/QN6+P6ZJSYvGjwdQYkuRS3ZgxertBa7E
/aAGETXKjgmq+iWa+sNRF9OkW4jc1nRZGvrLL9BHLH4QiZeZPtL179KwvhYsBQq4
hypiU6q4GulArX5a1TsPNF6eJpRWvp7A5iS2wGEbpg3uBKpf11hlzJ86ONhcq1Pt
vp4EUIoY50NhuaxqR48UKXcGO8mJdZ+kVp3YOguEroXb/JqjVLPQYJUe91M2hVSm
tb3rBGX+f+URQr1ZE72z
=VOD4
-----END PGP SIGNATURE-----
