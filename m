Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab0FOXQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 19:16:38 -0400
Received: from daytona.panasas.com ([67.152.220.89]:53291 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754606Ab0FOXQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 19:16:37 -0400
Message-ID: <4C1809D3.7030707@panasas.com>
Date: Tue, 15 Jun 2010 19:16:35 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Liu Aleaxander <aleaxander@gmail.com>
CC: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [PATCH] um: Include missing header file in	os-linux/mem.c
References: <AANLkTikziSEDW07YiiJs6ny6JLhSQ-TGvdw_kTroIIx5@mail.gmail.com>
In-Reply-To: <AANLkTikziSEDW07YiiJs6ny6JLhSQ-TGvdw_kTroIIx5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2010 23:16:36.0666 (UTC) FILETIME=[CD4B41A0:01CB0CE0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 04:06 AM, Liu Aleaxander wrote:
> The os-linux/mem.c file calls fchmod function, which is declared in sys/stat.h
> header file, so include it.
> 

Yes. I have the same patch.

Apparently it's new for Fedora 13. Previous Fedora's are compiling fine.
I guess something has changed with the new gcc headers include sequence

Thanks
Boaz 

> Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
> ---
>  arch/um/os-Linux/mem.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
> index 93a11d7..e696144 100644
> --- a/arch/um/os-Linux/mem.c
> +++ b/arch/um/os-Linux/mem.c
> @@ -10,6 +10,7 @@
>  #include <errno.h>
>  #include <fcntl.h>
>  #include <string.h>
> +#include <sys/stat.h>
>  #include <sys/mman.h>
>  #include <sys/param.h>
>  #include "init.h"
> 
> 

