Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0CQQxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:53:46 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:48163 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab0CQQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:53:44 -0400
Message-ID: <4BA108E8.7070307@oracle.com>
Date: Wed, 17 Mar 2010 09:52:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: rename PCI/PCI-DMA-mapping.txt to DMA-API-HOWTO.txt
References: <20100317090657E.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100317090657E.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BA108EF.0022:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/10 17:07, FUJITA Tomonori wrote:
> This patch renames PCI/PCI-DMA-mapping.txt to DMA-API-HOWTO.txt.
> 
> The commit 51e7364ef281e540371f084008732b13292622f0 "Documentation:
> rename PCI-DMA-mapping.txt to DMA-API-HOWTO.txt" was supposed to do
> this but it didn't.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  Documentation/DMA-API-HOWTO.txt       |  758 +++++++++++++++++++++++++++++++++
>  Documentation/PCI/PCI-DMA-mapping.txt |  758 ---------------------------------
>  2 files changed, 758 insertions(+), 758 deletions(-)
>  create mode 100644 Documentation/DMA-API-HOWTO.txt
>  delete mode 100644 Documentation/PCI/PCI-DMA-mapping.txt

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


Thanks.
-- 
~Randy
