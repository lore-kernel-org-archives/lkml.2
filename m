Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab1HEMPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:15:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab1HEMPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:15:16 -0400
Message-ID: <4E3BDECE.90103@redhat.com>
Date: Fri, 05 Aug 2011 09:15:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Nils Carlson <nils.carlson@ericsson.com>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
Subject: Re: [PATCH] i7core_edac: Add xeon 5600 generic non core registers
 v2
References: <1312531750-14933-1-git-send-email-nils.carlson@ericsson.com> <1312531750-14933-2-git-send-email-nils.carlson@ericsson.com>
In-Reply-To: <1312531750-14933-2-git-send-email-nils.carlson@ericsson.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nils,

Em 05-08-2011 05:09, Nils Carlson escreveu:
> From: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
> 
> Changes since v1:
> Reposted as a single patch and not as part of a series.
> 
> Signed-off-by: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
> ---
>  drivers/edac/i7core_edac.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
> index 465cbc2..b1f6889 100644
> --- a/drivers/edac/i7core_edac.c
> +++ b/drivers/edac/i7core_edac.c
> @@ -322,6 +322,9 @@ static const struct pci_id_descr pci_dev_descr_lynnfield[] = {
>  };
>  
>  static const struct pci_id_descr pci_dev_descr_i7core_westmere[] = {
> +		/* Generic Non-core registers */
> +	{ PCI_DESCR(0, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_REV2) },
> +
>  		/* Memory controller */
>  	{ PCI_DESCR(3, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_MCR_REV2)     },
>  	{ PCI_DESCR(3, 1, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_TAD_REV2)  },

The entry for this device is already at the end of the table.

Cheers,
Mauro
