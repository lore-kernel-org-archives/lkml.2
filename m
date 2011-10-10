Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1JJQx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:53:27 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:52601 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab1JJQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:53:26 -0400
Message-ID: <4E9322FA.90805@linux.vnet.ibm.com>
Date: Mon, 10 Oct 2011 13:53:14 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Stefan Berger <stefanb@linux.vnet.ibm.com>, a.miskiewicz@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] TPM suspend regression fix
References: <4E931A7E.60800@linux.vnet.ibm.com>
In-Reply-To: <4E931A7E.60800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/11 13:17, Rajiv Andrade wrote:
> Hi James,
>
> Please pull the change since commit 
> e00fb3f7af111d1b3252f7d622213d2e22be65f5 in
> your next branch:
>
>   TOMOYO: Fix domain transition failure warning. (2011-09-28 11:53:15 
> +1000)
>
> that is available in the git repository at:
>   git://github.com/srajiv/tpm.git for-james
>
> Stefan Berger (1):
>       TPM: Refuse activation of tpm_tis driver if TPM is not working 
> correctly
>
>  drivers/char/tpm/tpm_tis.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
Hi James,

Please do not consider this one, there's one more suspend fix I'm 
working on, so it's better
to have all them in one request instead.

Thanks,
Rajiv
