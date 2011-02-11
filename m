Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1BKGiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 01:38:20 -0500
Received: from tundra.namei.org ([65.99.196.166]:56503 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1BKGiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 01:38:19 -0500
Date: Fri, 11 Feb 2011 17:38:13 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Stefan Berger <stefanb@us.ibm.com>,
        Guillaume Chazarain <guichaz@gmail.com>
Subject: Re: [GIT PULL] TPM timeout fix
In-Reply-To: <4D54B688.4010307@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1102111737460.28805@tundra.namei.org>
References: <4D54B688.4010307@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011, Rajiv Andrade wrote:

> Hi James,
> 
> Please pull from:
>     git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd/ for-james
> 
> The following change corrects the logic used to extract the timeouts returned
> from a TPM.
> These values are used subsequently in the TPM device driver, and if relying on
> the default values,
> some commands may not have its proper timeout considered. This is a bugfix for
> the current linus tree.
> 
> Stefan Berger (1):
>       tpm_tis: Use timeouts returned from TPM

Thanks, applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#for-linus


-- 
James Morris
<jmorris@namei.org>
