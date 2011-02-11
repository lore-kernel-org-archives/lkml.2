Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1BKEJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 23:09:51 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:53385 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1BKEJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 23:09:50 -0500
Message-ID: <4D54B688.4010307@linux.vnet.ibm.com>
Date: Fri, 11 Feb 2011 02:09:44 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: linux-kernel@vger.kernel.org, Stefan Berger <stefanb@us.ibm.com>,
        Guillaume Chazarain <guichaz@gmail.com>
Subject: [GIT PULL] TPM timeout fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11021104-5054-0000-0000-000000182FB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull from:
     git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd/ for-james

The following change corrects the logic used to extract the timeouts returned from a TPM.
These values are used subsequently in the TPM device driver, and if relying on the default values,
some commands may not have its proper timeout considered. This is a bugfix for the current linus tree.

Stefan Berger (1):
       tpm_tis: Use timeouts returned from TPM

Diffstat:
  drivers/char/tpm/tpm.c     |   18 ++++++++++++++++--
  drivers/char/tpm/tpm.h     |    2 ++
  drivers/char/tpm/tpm_tis.c |    4 +++-
  3 files changed, 21 insertions(+), 3 deletions(-)


