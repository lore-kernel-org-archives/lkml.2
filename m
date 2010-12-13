Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0LMTSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:18:34 -0500
Received: from claw.goop.org ([74.207.240.146]:42358 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab0LMTSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:18:33 -0500
Message-ID: <4D067186.9090009@goop.org>
Date: Mon, 13 Dec 2010 11:18:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xensource.com, Jan Beulich <JBeulich@novell.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 6/9] pci/xen: Make xen_[find|register|unregister]_domain_owner
 be _GPL
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com> <1292263303-31680-7-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1292263303-31680-7-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 10:01 AM, Konrad Rzeszutek Wilk wrote:
> EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL.

You should fold this into the base patch.

    J

> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/pci/xen.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 6d2a986..0fa23c8 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -445,7 +445,7 @@ int xen_find_device_domain_owner(struct pci_dev *dev)
>  	spin_unlock(&dev_domain_list_spinlock);
>  	return domain;
>  }
> -EXPORT_SYMBOL(xen_find_device_domain_owner);
> +EXPORT_SYMBOL_GPL(xen_find_device_domain_owner);
>  
>  int xen_register_device_domain_owner(struct pci_dev *dev, uint16_t domain)
>  {
> @@ -467,7 +467,7 @@ int xen_register_device_domain_owner(struct pci_dev *dev, uint16_t domain)
>  	spin_unlock(&dev_domain_list_spinlock);
>  	return 0;
>  }
> -EXPORT_SYMBOL(xen_register_device_domain_owner);
> +EXPORT_SYMBOL_GPL(xen_register_device_domain_owner);
>  
>  int xen_unregister_device_domain_owner(struct pci_dev *dev)
>  {
> @@ -484,4 +484,4 @@ int xen_unregister_device_domain_owner(struct pci_dev *dev)
>  	kfree(owner);
>  	return 0;
>  }
> -EXPORT_SYMBOL(xen_unregister_device_domain_owner);
> +EXPORT_SYMBOL_GPL(xen_unregister_device_domain_owner);

