Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0LARzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:55:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:61924 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0LARzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:55:31 -0500
Date: Wed, 1 Dec 2010 09:53:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Subject: Re: [PATCH v16 14/17]Add a kconfig entry and make entry for mp
 device.
Message-Id: <20101201095348.07421ee5.randy.dunlap@oracle.com>
In-Reply-To: <a1c255bc496b7aaca26912790f8bb0162dd1f4bf.1291187695.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
	<a1c255bc496b7aaca26912790f8bb0162dd1f4bf.1291187695.git.xiaohui.xin@intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Dec 2010 16:08:25 +0800 xiaohui.xin@intel.com wrote:

> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
> Reviewed-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  drivers/vhost/Kconfig  |   10 ++++++++++
>  drivers/vhost/Makefile |    2 ++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index e4e2fd1..a6b8cbf 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -9,3 +9,13 @@ config VHOST_NET
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called vhost_net.
>  
> +config MEDIATE_PASSTHRU
> +	tristate "mediate passthru network driver (EXPERIMENTAL)"
> +	depends on VHOST_NET
> +	---help---
> +	  zerocopy network I/O support, we call it as mediate passthru to

	                       support; we call it "mediate passthru" to

> +	  be distiguish with hardare passthru.

	  distinguish it from hardware passthru.

> +
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called mpassthru.
> +


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
