Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab0ENVcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:32:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53150 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0ENVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Qs/HdRrujDbTKzRglVUpRr16srgA0YkelXKdTba/8B9x9UVqoUQZkcGdyyW/L7cQCP
         k+LgMZnKaquGuvP9OLI2QH0vAcLY8HDGCybdZoeSE7qCGkio3EQozbjvo3XZzSdH5txf
         nVugyvuXqbUodHwQ0YCZ4mVakMGbM3a8y5bM8=
Message-ID: <4BEDC155.8040204@pobox.com>
Date: Fri, 14 May 2010 17:32:05 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk, ysato@users.sourceforge.jp, tony.luck@intel.com,
       dhowells@redhat.com, kyle@mcmartin.ca, benh@kernel.crashing.org,
       schwidefsky@de.ibm.com, hare@suse.de, felipe.balbi@nokia.com
Subject: Re: [PATCH 13/13] drivers/ata: removing redundant ifdef
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com> <1273167377-14270-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-14-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 01:36 PM, Jiri Olsa wrote:
> wbr,
> jirka
>
>
> Signed-off-by: Jiri Olsa<jolsa@redhat.com>
> ---
>   drivers/ata/ahci.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 8b502f4..5326af2 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -3179,7 +3179,6 @@ static bool ahci_broken_online(struct pci_dev *pdev)
>   #ifdef CONFIG_ATA_ACPI
>   static void ahci_gtf_filter_workaround(struct ata_host *host)
>   {
> -#ifdef CONFIG_ATA_ACPI
>   	static const struct dmi_system_id sysids[] = {
>   		/*
>   		 * Aspire 3810T issues a bunch of SATA enable commands
> @@ -3220,7 +3219,6 @@ static void ahci_gtf_filter_workaround(struct ata_host *host)
>   			ata_for_each_dev(dev, link, ALL)
>   				dev->gtf_filter |= filter;
>   	}
> -#endif
>   }

I don't see this in the linux-next version of ahci.c, so I'm dropping 
this patch.


