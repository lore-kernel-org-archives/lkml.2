Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab0LMOpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:45:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52035 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab0LMOpW (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 13 Dec 2010 09:45:22 -0500
Date: Mon, 13 Dec 2010 09:44:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: linux-next: build failure after merge of the swiotlb-xen tree
Message-ID: <20101213144454.GA12054@dumpdata.com>
References: <20101213143322.90c45f81.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213143322.90c45f81.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 02:33:22PM +1100, Stephen Rothwell wrote:
> Hi Konrad,
> 
> After merging the swiotlb-xen tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Ahh, yes. I knew there was some patch that we forgot. Will fix it up today!
> 
> ERROR: "xenbus_dev_is_online" [drivers/xen/pciback/xen-pciback.ko] undefined!
> ERROR: "__xenbus_register_backend" [drivers/xen/pciback/xen-pciback.ko] undefined!
> 
> Caused by commit 443b2aafbdb509f218fcb8f4665f063e3a5e1a92 ("xen-pciback:
> Initial copy from linux-2.6.18.hg off pciback driver").
> 
> I have used the swiotlb-xen tree from next-20101210 for today.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/


