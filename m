Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab2BIUPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:15:45 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:46891 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab2BIUPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:15:43 -0500
Date: Thu, 9 Feb 2012 16:15:28 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, Jan Beulich <JBeulich@suse.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/tmem: cleanup
Message-ID: <20120209201527.GB14007@andromeda.dapyr.net>
References: <4F2C06A00200007800071071@nat28.tlf.novell.com> <d86f0be9-1530-47bd-b3fd-8c251e563b25@default> <4F2F998202000078000714CD@nat28.tlf.novell.com> <e871af1b-8003-4d3d-8fde-ea40545ff9fe@default> <4F3012B602000078000716AB@nat28.tlf.novell.com> <20120206170224.GD23240@phenom.dumpdata.com> <69f22464-d460-450c-a81b-77bda8cc7568@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f22464-d460-450c-a81b-77bda8cc7568@default>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jan, you're right, I had forgotten about that "chained" dependency.
> Thanks and FWIW, on the entire original patch:
> 
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
>  

ok, applied to the tree.
> > It would be nice if all of it could become modules. That way HVM
> > device driver domains could load the whole thing without having much
> > built-in code in the kernel.
> > 
> > Is it possible to do that?
> 
> Konrad, my module expertise is very low, so I will leave that
> to Jan or someone else to answer or look into.

Sounds feasible, but would need to export some symbols. Hmm. Not sure.

> 
> Dan
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
