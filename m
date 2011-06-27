Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1F0PxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:53:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35781 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab1F0PxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:53:10 -0400
Date: Mon, 27 Jun 2011 11:52:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-input@vger.kernel.org
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen-kbdfront: enable xen-kbdfront for HVM
 guests
Message-ID: <20110627155252.GL6978@dumpdata.com>
References: <alpine.DEB.2.00.1106241730220.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1106241730220.12963@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E08A75F.0067:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 05:33:16PM +0100, Stefano Stabellini wrote:
> xen-kbdfront: enable xen-kbdfront for HVM guests too

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Dmitry, can you pick this up for 3.1 please?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
> index 62bae99..ad2e51c 100644
> --- a/drivers/input/misc/xen-kbdfront.c
> +++ b/drivers/input/misc/xen-kbdfront.c
> @@ -373,7 +373,7 @@ static struct xenbus_driver xenkbd_driver = {
>  
>  static int __init xenkbd_init(void)
>  {
> -	if (!xen_pv_domain())
> +	if (!xen_domain())
>  		return -ENODEV;
>  
>  	/* Nothing to do if running in dom0. */
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
