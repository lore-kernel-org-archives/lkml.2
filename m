Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0K3Wh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:37:29 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38736 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab0K3Wh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:37:28 -0500
Message-ID: <4CF57C7A.5060905@oracle.com>
Date: Tue, 30 Nov 2010 14:36:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5535-mfd: fix warning on x86-64 (v2)
References: <20101129115257.9a78ad14.sfr@canb.auug.org.au>	<20101129204410.339805ef@queued.net>	<20101130102257.008fb652.randy.dunlap@oracle.com> <20101130135439.2e293d65@queued.net>
In-Reply-To: <20101130135439.2e293d65@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/10 13:54, Andres Salomon wrote:
> 
> ARRAY_SIZE() returns size_t; use %zu instead of %d so that we don't
> get warnings on x86-64.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Glad you used %zu instead of %zd.

> ---
>  drivers/mfd/cs5535-mfd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
> index b141ca7..59ca6f1 100644
> --- a/drivers/mfd/cs5535-mfd.c
> +++ b/drivers/mfd/cs5535-mfd.c
> @@ -103,7 +103,7 @@ static int __devinit cs5535_mfd_probe(struct pci_dev *pdev,
>  		goto err_disable;
>  	}
>  
> -	dev_info(&pdev->dev, "%d devices registered.\n",
> +	dev_info(&pdev->dev, "%zu devices registered.\n",
>  			ARRAY_SIZE(cs5535_mfd_cells));
>  
>  	return 0;


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
