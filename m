Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2AWWPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:15:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2AWWPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:15:50 -0500
Date: Mon, 23 Jan 2012 14:11:55 -0800
From: Greg KH <gregkh@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        dave@linux.vnet.ibm.com, cascardo@holoscopio.com,
        sjenning@linux.vnet.ibm.com
Subject: Re: [PATCH] zcache fix for 3.3-rc1.
Message-ID: <20120123221155.GA10265@suse.de>
References: <1327355540-30681-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327355540-30681-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 04:52:19PM -0500, Konrad Rzeszutek Wilk wrote:
> Hey Greg,
> 
> I posted this patch some time ago  [https://lkml.org/lkml/2012/1/13/253]
> but I am not seeing it in you tree.

Did you copy me on it?  I don't see it anywhere in my to-apply queues.

> Was wondering if you could stick this patch in your tree? It fixes
> a performance regressions which is quite noticable in small memory systems
> where a 'swapoff' ends up taking more than it should.

So this is needed for 3.3?  How about older kernels?  3.2?  3.0?

thanks,

greg k-h
