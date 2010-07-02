Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0GBVdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 17:33:11 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:49591 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752118Ab0GBVdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 17:33:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OBnjHbbgYDvu8tuzV7Eu5inu+UqcQlLRL9lcil8xD9M048HqkjB+TkxGPZXL5Or8Ii7BlcWon1Y8PbZBRuWMKa1ol62s6GAP9zlBjI0sOghyqsPmkKN0UDs44fZprP0h;
Date: Fri, 2 Jul 2010 14:30:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Michal Schmidt <mschmidt@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/25] pci-sysfs: remove casts from void*
Message-ID: <20100702143039.7bdac116@virtuousgeek.org>
In-Reply-To: <1277806529-31010-1-git-send-email-segooon@gmail.com>
References: <1277806529-31010-1-git-send-email-segooon@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010 14:15:28 +0400
Kulikov Vasiliy <segooon@gmail.com> wrote:

> Remove unnesessary casts from void*.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/pci/pci-sysfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index afd2fbf..7f8bc8c 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -734,7 +734,7 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
>  {
>  	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
>  						       struct device, kobj));
> -	struct resource *res = (struct resource *)attr->private;
> +	struct resource *res = attr->private;
>  	enum pci_mmap_state mmap_type;
>  	resource_size_t start, end;
>  	int i;

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
