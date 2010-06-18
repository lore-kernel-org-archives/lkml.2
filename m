Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab0FREng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:43:36 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44068 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab0FREnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:43:35 -0400
Date: Thu, 17 Jun 2010 21:44:27 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Neil Brown <neilb@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, hch@lst.de, bfields@citi.umich.edu
Subject: Re: weird umem vs nfsd regression
In-Reply-To: <Pine.LNX.4.64.1006172109010.6914@cobra.newdream.net>
Message-ID: <Pine.LNX.4.64.1006172130190.10542@cobra.newdream.net>
References: <Pine.LNX.4.64.1006171305320.8387@cobra.newdream.net>
 <20100617134706.6c5ad7f1.akpm@linux-foundation.org> <20100618125420.46fda9d6@notabene.brown>
 <Pine.LNX.4.64.1006172109010.6914@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Sage Weil wrote:
> I guess at this point I'll walk through those options one by one to see 
> which one changes the behavior.

Hmm, CONFIG_IOMMU_DEBUG=y makes the hang go away.

sage
