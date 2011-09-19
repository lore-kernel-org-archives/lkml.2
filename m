Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1ISL2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:28:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48610 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab1ISL2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:28:07 -0400
Subject: [PULL] lib: please pull hex2bin for security-testing next
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 07:28:04 -0400
Message-ID: <1316431684.3191.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Part of the "target" hex2bin patch has been dropped. The remainder of the 'target'
hex2bin patch will be upstreamed through the 'target' tree. Please pull the hex2bin
patches:

The following changes since commit 6bce98edc3365a8f780ff3944ac7992544c194fe:

  TOMOYO: Allow specifying domain transition preference. (2011-09-19 10:09:59 +1000)

are available in the git repository at:
  git://github.com/mzohar/linux-evm.git next-hex2bin

Mimi Zohar (2):
      lib: add unpack_hex_byte()
      lib: add error checking to hex2bin

Tetsuo Handa (2):
      trusted-keys: check hex2bin result
      encrypted-keys: check hex2bin result

 include/linux/kernel.h                   |   23 ++++++++++++++++++++++-
 lib/hexdump.c                            |   11 +++++++----
 security/keys/encrypted-keys/encrypted.c |   11 ++++++++---
 security/keys/trusted.c                  |   15 +++++++++++----
 4 files changed, 48 insertions(+), 12 deletions(-)

thanks,

Mimi


