Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1HBQn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:43:26 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41557 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643Ab1HBQnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:43:20 -0400
X-Sasl-enc: XNivqR1A10Ebp9eh7yR/0vAJAnrHMAQklhMCfdrzXZoY 1312303399
Date: Tue, 2 Aug 2011 09:35:29 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        stable <stable@kernel.org>
Subject: Re: [stable] [perf] overflow/perf_count_sw_cpu_clock crashes recent
 kernels
Message-ID: <20110802163529.GA1341@kroah.com>
References: <alpine.DEB.2.00.1107221210160.21367@cl320.eecs.utk.edu>
 <alpine.DEB.2.00.1107271446460.406@cl320.eecs.utk.edu>
 <1311878830.2617.373.camel@laptop>
 <20110729050514.GA24999@kroah.com>
 <1311940750.5890.348.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311940750.5890.348.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 01:59:10PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 22:05 -0700, Greg KH wrote:
> > 
> > What is that commit id so it can be properly referenced in the patch
> > below?  And what tree should this patch go into?  .39?  3.0?  Anything
> > newer? 
> 
> .32+ in as far as anybody is still maintaining them, if it fails to
> apply to any of them (quite possible) do tell and I can provide
> backports etc..

I've applied it to 3.0, and it didn't apply to any older kernel due to
file movements, so if you could, can you provide a version for
.32-stable?

thanks,

greg k-h
