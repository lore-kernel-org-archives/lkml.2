Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2CESHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:07:47 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49225 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab2CESHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:07:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ngupta@vflare.org designates 10.52.178.40 as permitted sender) smtp.mail=ngupta@vflare.org
Message-ID: <4F5500EF.9080609@vflare.org>
Date: Mon, 05 Mar 2012 13:07:43 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] staging: zsmalloc: remove SPARSEMEM dependency
References: <1330968804-8098-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1330968804-8098-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 12:33 PM, Seth Jennings wrote:

> This patch series removes the dependency zsmalloc has on SPARSEMEM;
> more specifically the assumption that MAX_PHYSMEM_BITS is defined.
> 
> Based on greg/staging-next.
> 
> Seth Jennings (5):
>   staging: zsmalloc: move object/handle masking defines
>   staging: zsmalloc: add ZS_MAX_PAGES_PER_ZSPAGE
>   staging: zsmalloc: calculate MAX_PHYSMEM_BITS if not defined
>   staging: zsmalloc: change ZS_MIN_ALLOC_SIZE
>   staging: zsmalloc: remove SPARSEMEM dep from Kconfig
> 
>  drivers/staging/zsmalloc/Kconfig         |    2 +-
>  drivers/staging/zsmalloc/zsmalloc-main.c |   14 +---------
>  drivers/staging/zsmalloc/zsmalloc_int.h  |   43 +++++++++++++++++++++++++-----
>  3 files changed, 38 insertions(+), 21 deletions(-)
> 


For the entire series:

Acked-by: Nitin Gupta <ngupta@vflare.org>


Thanks for the fixes.
Nitin
