Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab1F1V4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:56:18 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39961 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1F1V4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:56:14 -0400
Subject: [PULL] ecryptfs-keys: please pull for security-testing next
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 17:56:02 -0400
Message-ID: <1309298162.2760.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull the ecryptfs encrypted key extension patches.

The following changes since commit 4d67431f80b1b822f0286afc9123ee453eac7334:

  KEYS: Don't return EAGAIN to keyctl_assume_authority() (2011-06-14 15:03:29 +1000)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/zohar/ima-2.6.git next-ecryptfs-keys

Roberto Sassu (7):
      encrypted_keys: avoid dumping the master key if the request fails
      encrypted-keys: fixed valid_master_desc() function description
      encrypted-keys: added additional debug messages
      encrypted-keys: add key format support
      eCryptfs: export global eCryptfs definitions to include/linux/ecryptfs.h
      encrypted-keys: add ecryptfs format support
      eCryptfs: added support for the encrypted key type

thanks,

Mimi

