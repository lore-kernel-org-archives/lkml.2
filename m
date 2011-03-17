Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1CQC0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:26:15 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:39716 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1CQC0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:26:09 -0400
Message-ID: <4D81713B.2060001@linux.vnet.ibm.com>
Date: Wed, 16 Mar 2011 23:26:03 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Huewe <huewe.external.infineon@googlemail.com>
Subject: Re: [GIT PULL] TPM driver robustness fixes
References: <4D81708D.5090607@linux.vnet.ibm.com>
In-Reply-To: <4D81708D.5090607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11031702-9254-0000-0000-0000011CE05B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/16/2011 11:23 PM, Rajiv Andrade wrote:
> Hi James,
>
>
> The following changes since commit 
> 2e270d84223262a38d4755c61d55f5c73ea89e56:
>
>   Merge branch 'for-linus' of 
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2011-03-16 
> 13:26:17 -0700)
>
> are available in the git repository at:
>
>   git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd/ for-james
>
> Peter Huewe (3):
>
>       This patch changes the call of tpm_transmit by supplying the 
> size of the userspace buffer instead of TPM_BUFSIZE
>
>       This patch fixes information leakage to the userspace by 
> initializing the data buffer to zero
>
>       Since the buffer might contain security related data it might be 
> a good idea to zero the buffer after we have copied it to userspace.

Given the nature of these changes, they should go to current linus as 
bug fixes.

Thanks,
Rajiv

