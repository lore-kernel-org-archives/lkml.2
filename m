Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1LHITs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:19:48 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:56149 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1LHITr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:19:47 -0500
X-IronPort-AV: E=Sophos;i="4.71,319,1320624000"; 
   d="scan'208";a="9355623"
Subject: Re: [Xen-devel] [PATCH 1/4] xen: Add privcmd device driver
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Bastian Blank <waldi@debian.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Thu, 8 Dec 2011 08:19:45 +0000
In-Reply-To: <1323292396-19523-2-git-send-email-waldi@debian.org>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
	 <1323292396-19523-2-git-send-email-waldi@debian.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323332385.2969.46.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 21:13 +0000, Bastian Blank wrote:
> +static int __init privcmd_init(void)
> +{
> +       int err;
> +
> +       if (!xen_domain())
> +               return -ENODEV;
> +
> +       err = misc_register(&privcmd_dev);
> +       if (err != 0) {
> +               printk(KERN_ERR "Could not register privcmd device\n"); 

Should say "...register Xen privcmd device". Otherwise:

Acked-by: Ian Campbell <ian.campbell@citrix.com>



