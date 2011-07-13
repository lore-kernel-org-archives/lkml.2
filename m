Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab1GMDOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 23:14:09 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:48593 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab1GMDOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 23:14:07 -0400
Message-ID: <4E1D0D6F.5040703@linux.vnet.ibm.com>
Date: Wed, 13 Jul 2011 00:13:51 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull TPM fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11071303-2362-0000-0000-000004315CEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull this set of TPM fixes since commit 97fb35e413f256ded07b88c73b3d932ec31ea84e

  TOMOYO: Enable conditional ACL. (2011-07-11 11:05:34 +1000)

that are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/srajiv/tpm-2.6.git for-james

Stefan Berger (12):
      tpm: Use durations returned from TPM
      tpm: Adjust the durations if they are too small
      tpm_tis: Introduce durations sysfs entry
      tpm: Use interface timeouts returned from the TPM
      tpm: Adjust interface timeouts if they are too small
      tpm_tis: Add timeouts sysfs entry
      tpm: Fix display of data in pubek sysfs entry
      tpm_tis: Re-enable interrupts upon (S3) resume
      tpm_tis: Delay ACPI S3 suspend while the TPM is busy
      tpm_tis: Fix the probing for interrupts
      tpm_tis: Probing function for Intel iTPM bug
      tpm: Fix a typo

 drivers/char/tpm/tpm.c     |  102 +++++++++++++++++++-------
 drivers/char/tpm/tpm.h     |    7 ++
 drivers/char/tpm/tpm_tis.c |  174 ++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 241 insertions(+), 42 deletions(-)

Thanks,
Rajiv

