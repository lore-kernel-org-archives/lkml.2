Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab0GHQOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 12:14:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56906 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab0GHQOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 12:14:36 -0400
Date: Thu, 8 Jul 2010 09:13:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mike Thomas <rmthomas@sciolus.org>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/easycap: Add dependencies to Kconfig
Message-Id: <20100708091330.e23a5ea1.randy.dunlap@oracle.com>
In-Reply-To: <1277580059.5924.9.camel@E7500.sciolus.org>
References: <1277580059.5924.9.camel@E7500.sciolus.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C35F962.01CE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010 20:20:59 +0100 Mike Thomas wrote:

> The "depends on" line was inadvertently omitted from the inaugural patch.
> 
> Signed-off-by: Mike Thomas <rmthomas@sciolus.org>
> ---
>  drivers/staging/easycap/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/easycap/Kconfig b/drivers/staging/easycap/Kconfig
> index 9bff7cf..bd96f39 100644
> --- a/drivers/staging/easycap/Kconfig
> +++ b/drivers/staging/easycap/Kconfig
> @@ -1,5 +1,6 @@
>  config EASYCAP
>  	tristate "EasyCAP USB ID 05e1:0408 support"
> +	depends on USB && VIDEO_DEV
>  
>  	---help---
>  	  This is an integrated audio/video driver for EasyCAP cards with
> -- 

Thanks for the patch.

Greg, please merge...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
