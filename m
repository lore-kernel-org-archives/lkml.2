Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab1INV51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 17:57:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41863 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933402Ab1INV5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 17:57:25 -0400
Subject: [PULL] encrypted-keys: please pull for security-testing next
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 17:57:20 -0400
Message-ID: <1316037440.2777.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
x-cbid: 11091421-8974-0000-0000-0000002884B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

The previously posted "encrypted-keys: remove trusted-keys dependency"
moved trusted keys to its own directory keys/encrypted-keys and removed
the trusted-keys dependency.  Other than splitting this into two
separate patches, nothing else has changed since posted.

Please pull the following 3 patches from the temporary repo:

The following changes since commit a8f7640963ada66c412314c3559c11ff6946c1a5:

  TOMOYO: Avoid race when retrying "file execute" permission check. (2011-09-14 08:27:07 +1000)

are available in the git repository at:
  git://github.com/mzohar/linux-evm.git #next-evm

Mimi Zohar (3):
      encrypted-keys: create encrypted-keys directory
      encrypted-keys: remove trusted-keys dependency
      evm: remove TCG_TPM dependency

 security/Kconfig                                   |    4 +-
 security/integrity/evm/Kconfig                     |    3 +-
 security/keys/Makefile                             |    2 +-
 security/keys/encrypted-keys/Makefile              |    6 +++
 .../keys/{ => encrypted-keys}/ecryptfs_format.c    |    0
 .../keys/{ => encrypted-keys}/ecryptfs_format.h    |    0
 security/keys/{ => encrypted-keys}/encrypted.c     |   35 ++++------------
 security/keys/{ => encrypted-keys}/encrypted.h     |   11 +++++
 security/keys/encrypted-keys/masterkey_trusted.c   |   44 ++++++++++++++++++++
 9 files changed, 74 insertions(+), 31 deletions(-)
 create mode 100644 security/keys/encrypted-keys/Makefile
 rename security/keys/{ => encrypted-keys}/ecryptfs_format.c (100%)
 rename security/keys/{ => encrypted-keys}/ecryptfs_format.h (100%)
 rename security/keys/{ => encrypted-keys}/encrypted.c (97%)
 rename security/keys/{ => encrypted-keys}/encrypted.h (81%)
 create mode 100644 security/keys/encrypted-keys/masterkey_trusted.c

thanks,

Mimi

