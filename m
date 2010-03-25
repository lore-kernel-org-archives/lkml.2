Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0CYFXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:23:41 -0400
Received: from quartz.orcorp.ca ([139.142.54.143]:51928 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab0CYFXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:23:40 -0400
Date: Wed, 24 Mar 2010 23:23:28 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] TPM: Provide a tpm_tis OF driver
Message-ID: <20100325052328.GB9769@obsidianresearch.com>
References: <20100309200135.GF30462@obsidianresearch.com> <1269490841.12676.32.camel@blackbox.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269490841.12676.32.camel@blackbox.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 01:20:41AM -0300, Rajiv Andrade wrote:

> Why not 
> 
> +#ifdef CONFIG_OF
> +	return of_register_platform_driver(&tis_of_driver);
> +#elif CONFIG_PNP
> +	return pnp_register_driver(&tis_pnp_driver);
> +#endif
> 
> ?

AFAIK they are not exclusive options? I can't imagine anyone building
a kernel with both, but the rest of the patch is designed to allow
both at once..

> Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Thanks - who can pick this up to feed it upstream?

Jason
