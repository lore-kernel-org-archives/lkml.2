Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab1ITT5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:57:33 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36935 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab1ITT5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:57:32 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Arnaud Lacombe <lacombar@gmail.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
Subject: [PATCH v1 0/4] lib: hex2bin error checking
Date: Tue, 20 Sep 2011 15:52:49 -0400
Message-Id: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
x-cbid: 11092019-8974-0000-0000-0000004BC091
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hex2bin converts a hexadecimal string to its binary representation.

This version simply adds error checking to the existing hex2bin().
On success, hex2bin returns 0, on failure -1.

Changelog v1
- refreshed the trusted, encrypted, 'target' patches
- removed unpack_hex_byte()
- changed return code from boolean to int

Mimi Zohar (4):
  lib: add error checking to hex2bin
  trusted-keys: check hex2bin result
  encrypted-keys: check hex2bin result
  target: check hex2bin result

 drivers/target/target_core_fabric_lib.c  |   11 +++++++++--
 include/linux/kernel.h                   |    2 +-
 lib/hexdump.c                            |   15 +++++++++++----
 security/keys/encrypted-keys/encrypted.c |   14 +++++++++++---
 security/keys/trusted.c                  |   19 +++++++++++++++----
 5 files changed, 47 insertions(+), 14 deletions(-)

-- 
1.7.3.4

