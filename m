Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1KPX2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 18:28:38 -0500
Received: from tundra.namei.org ([65.99.196.166]:52077 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab1KPX2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 18:28:37 -0500
Date: Thu, 17 Nov 2011 10:26:31 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        roberto.sassu@polito.it, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PULL] TPM: error handling and infrastructure improvements
In-Reply-To: <4EC3AFAE.3010804@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1111171026250.20730@tundra.namei.org>
References: <4EC3AFAE.3010804@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011, Rajiv Andrade wrote:

> Hi James,
> 
> Please pull the following changes since commit
> e163bc8e4a0cd1cdffadb58253f7651201722d56:
> 
>   Documentation: clarify the purpose of LSMs (2011-11-16 12:37:27 +1100)
> 
> that are available in the git repository at:
>   git://github.com/srajiv/tpm.git for-james

Applied.

> 
> Rajiv Andrade (4):
>       TPM: Use vendor specific function for status probe
>       TPM: Export wait_for_stat for other vendor specific drivers
>       TPM: NSC and TIS drivers X86 dependency fix
>       TPM: fix transmit_cmd error logic
> 
> Stefan Berger (5):
>       tpm: Have tpm_get_timeouts return an error code
>       tpm: Cleanup tpm_continue_selftest
>       tpm: Introduce function to poll for result of self test
>       tpm_tis: Check return code from getting timeouts/durations
>       tpm_tis: add delay after aborting command
> 
>  drivers/char/tpm/Kconfig   |    2 +
>  drivers/char/tpm/tpm.c     |  137
> +++++++++++++++++++++++++++++++++++++-------
>  drivers/char/tpm/tpm.h     |    9 ++-
>  drivers/char/tpm/tpm_tis.c |   84 +++++++++------------------
>  4 files changed, 152 insertions(+), 80 deletions(-)
> 
> 

-- 
James Morris
<jmorris@namei.org>
