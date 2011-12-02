Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1LBTTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:19:51 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45844 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437Ab1LBTTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:19:36 -0500
X-Sasl-enc: 3pk/Qf5BjsN1w72SSLqoXPi6R/lqRLbTK5kypMf6KSwJ 1322853575
Date: Fri, 2 Dec 2011 11:18:24 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fengguang.wu@intel.com
Subject: Re: Add simple way to add statistic counters to debugfs
Message-ID: <20111202191824.GB13613@kroah.com>
References: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 10:43:24AM -0800, Andi Kleen wrote:
> This extends debugfs to make it very simple to add per cpu counters
> statistics that are exported there. This is useful for all kind
> of debugging situations. The counters have very little overhead
> and are simpler to use than trace points.
> 
> This is the infrastructure for debugfs and a demo application 
> to instrument the dcache RCU which I developed some time ago
> to track down some problems there.
> 
> Posting here also so that Fengguang can use it.
> 
> Module support is still missing, but could be added without too 
> much work.

I like this a lot, very nice job.  I just had one comment with the first
patch.

And yes, I would like module support as well, but others can add that if
they really need it :)

Care to fix up the first patch and I'll be glad to take the two debugfs
patches and any others if you want me to.

thanks,

greg k-h
