Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab0CSGG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 02:06:28 -0400
Received: from quartz.orcorp.ca ([139.142.54.143]:60376 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab0CSGG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 02:06:26 -0400
Date: Fri, 19 Mar 2010 00:06:21 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] PPC: Skip over OF_DT_NOP when unflattening the device tree
Message-ID: <20100319060621.GC28042@obsidianresearch.com>
References: <20100309193021.GD30462@obsidianresearch.com> <1268977838.8599.53.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268977838.8599.53.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 04:50:38PM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2010-03-09 at 12:30 -0700, Jason Gunthorpe wrote:
> > NOPs within the property section are skipped, but NOPs between
> > OF_DT_END_NODE and OF_DT_BEGIN_NODE were not. My firmware NOPs out
> > entire nodes depending on various environment parameters.
> > 
> > of_scan_flat_dt already handles NOP more generally..
> 
> Good catch, though that code has now moved over to drivers/of
> and is a bit different. Grant is going to fix it up though.

Ah, I based the patch off 2.6.33.. 

Grant: let me know if you need some help/testing, nice to run into you
again.

Jason
