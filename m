Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2AWWZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:25:05 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:55650 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab2AWWZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:25:03 -0500
Date: Mon, 23 Jan 2012 17:22:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        dave@linux.vnet.ibm.com, cascardo@holoscopio.com,
        sjenning@linux.vnet.ibm.com
Subject: Re: [PATCH] zcache fix for 3.3-rc1.
Message-ID: <20120123222238.GB31852@phenom.dumpdata.com>
References: <1327355540-30681-1-git-send-email-konrad.wilk@oracle.com>
 <20120123221155.GA10265@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123221155.GA10265@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F1DDE38.001B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 02:11:55PM -0800, Greg KH wrote:
> On Mon, Jan 23, 2012 at 04:52:19PM -0500, Konrad Rzeszutek Wilk wrote:
> > Hey Greg,
> > 
> > I posted this patch some time ago  [https://lkml.org/lkml/2012/1/13/253]
> > but I am not seeing it in you tree.
> 
> Did you copy me on it?  I don't see it anywhere in my to-apply queues.

Ugh, I did not - I seemed to have forgotten to CC you and had assumed you
would be omnipresent and would magically pick it up. Sorry about that mishap.
> 
> > Was wondering if you could stick this patch in your tree? It fixes
> > a performance regressions which is quite noticable in small memory systems
> > where a 'swapoff' ends up taking more than it should.
> 
> So this is needed for 3.3?  How about older kernels?  3.2?  3.0?

That would be splendid if you could stick it on the stable tree :-)

> 
> thanks,
> 
> greg k-h
