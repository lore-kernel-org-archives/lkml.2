Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab0KANqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:46:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45224 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab0KANqe (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 1 Nov 2010 09:46:34 -0400
Date: Mon, 1 Nov 2010 09:46:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Ryan Wilson <hap9@epoch.ncsc.mil>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Xen: Remove duplicate inclusion of header in
 xen-pcifront.c
Message-ID: <20101101134615.GA4672@dumpdata.com>
References: <alpine.LNX.2.00.1010301445550.7979@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1010301445550.7979@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 02:51:30PM +0200, Jesper Juhl wrote:
> In drivers/pci/xen-pcifront.c the xen/xenbus.h header is included twice - 
> once is enough.
> 
> (please keep me on CC for replies)

OK, it is in the queue. Thanks for spotting this.
