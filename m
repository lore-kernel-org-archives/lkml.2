Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2KFIo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:44:27 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:60334 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2KFIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:44:26 -0500
Date: Tue, 6 Nov 2012 09:45:11 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 037/104] arch/s390: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20121106084510.GB4339@osiris.de.ibm.com>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
 <1352156701-4038-38-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352156701-4038-38-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12110608-4966-0000-0000-000003FE452D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 03:03:54PM -0800, Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/s390/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 5dba755..3c8a70e 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -659,8 +659,8 @@ source "arch/s390/kvm/Kconfig"
> 
>  config S390_GUEST
>  	def_bool y
> -	prompt "s390 support for virtio devices (EXPERIMENTAL)"
> -	depends on 64BIT && EXPERIMENTAL
> +	prompt "s390 support for virtio devices"
> +	depends on 64BIT
>  	select VIRTUALIZATION
>  	select VIRTIO
>  	select VIRTIO_CONSOLE

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

