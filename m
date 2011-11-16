Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1KPMmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 07:42:36 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:48383 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1KPMmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 07:42:35 -0500
Message-ID: <4EC3AFAE.3010804@linux.vnet.ibm.com>
Date: Wed, 16 Nov 2011 10:42:22 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: roberto.sassu@polito.it, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PULL] TPM: error handling and infrastructure improvements
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11111612-1524-0000-0000-0000001FCDF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull the following changes since commit e163bc8e4a0cd1cdffadb58253f7651201722d56:

   Documentation: clarify the purpose of LSMs (2011-11-16 12:37:27 +1100)

that are available in the git repository at:
   git://github.com/srajiv/tpm.git for-james

Rajiv Andrade (4):
       TPM: Use vendor specific function for status probe
       TPM: Export wait_for_stat for other vendor specific drivers
       TPM: NSC and TIS drivers X86 dependency fix
       TPM: fix transmit_cmd error logic

Stefan Berger (5):
       tpm: Have tpm_get_timeouts return an error code
       tpm: Cleanup tpm_continue_selftest
       tpm: Introduce function to poll for result of self test
       tpm_tis: Check return code from getting timeouts/durations
       tpm_tis: add delay after aborting command

  drivers/char/tpm/Kconfig   |    2 +
  drivers/char/tpm/tpm.c     |  137 +++++++++++++++++++++++++++++++++++++-------
  drivers/char/tpm/tpm.h     |    9 ++-
  drivers/char/tpm/tpm_tis.c |   84 +++++++++------------------
  4 files changed, 152 insertions(+), 80 deletions(-)


