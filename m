Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab0DNSmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:42:13 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:59081 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab0DNSmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:42:12 -0400
Date: Wed, 14 Apr 2010 11:40:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Arce, Abraham" <x0066660@ti.com>, akpm <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: SubmittingDrivers: Resources
Message-Id: <20100414114027.3a40c9c2.randy.dunlap@oracle.com>
In-Reply-To: <27F9C60D11D683428E133F85D2BB4A53043D9EEB84@dlee03.ent.ti.com>
References: <27F9C60D11D683428E133F85D2BB4A53043D9EEB84@dlee03.ent.ti.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BC60C6D.0122:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 10:32:35 -0500 Arce, Abraham wrote:

> - Add additional location (Git) for the kernel master tree
> - Add reference to Git Project
> 
> Signed-off-by: Abraham Arce <x0066660@ti.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  Documentation/SubmittingDrivers |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/SubmittingDrivers b/Documentation/SubmittingDrivers
> index 99e72a8..1ed68d1 100644
> --- a/Documentation/SubmittingDrivers
> +++ b/Documentation/SubmittingDrivers
> @@ -130,6 +130,8 @@ Linux kernel master tree:
>  	ftp.??.kernel.org:/pub/linux/kernel/...
>  	?? == your country code, such as "us", "uk", "fr", etc.
>  
> +	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git
> +
>  Linux kernel mailing list:
>  	linux-kernel@vger.kernel.org
>  	[mail majordomo@vger.kernel.org to subscribe]
> @@ -160,3 +162,7 @@ How to NOT write kernel driver by Arjan van de Ven:
>  
>  Kernel Janitor:
>  	http://janitor.kernelnewbies.org/
> +
> +GIT, Fast Version Control System:
> +	http://git-scm.com/
> +
> -- 


---
~Randy
