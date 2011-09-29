Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab1I2N4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:56:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50283 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1I2N4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:56:24 -0400
Date: Thu, 29 Sep 2011 09:55:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: jeremy@goop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v5 2/2] xen: modify kernel mappings
 corresponding to granted pages
Message-ID: <20110929135558.GA31321@phenom.oracle.com>
References: <alpine.DEB.2.00.1109291148340.3519@kaball-desktop>
 <1317293876-23891-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317293876-23891-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E847901.0074,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /* Xen machine address */
> @@ -31,8 +32,10 @@ typedef struct xpaddr {
>  #define INVALID_P2M_ENTRY	(~0UL)
>  #define FOREIGN_FRAME_BIT	(1UL<<(BITS_PER_LONG-1))
>  #define IDENTITY_FRAME_BIT	(1UL<<(BITS_PER_LONG-2))
> +#define GRANT_FRAME_BIT	(1UL<<(BITS_PER_LONG-3))

I am going to change that to (BITS_PER_LONG-1) as we aren't
using the P2M. (and add that comment in the file).

And both patches are now in 3.2 queue.

