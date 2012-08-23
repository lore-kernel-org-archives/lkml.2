Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964947Ab2HWR7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:59:07 -0400
Received: from fieldses.org ([174.143.236.118]:55253 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327Ab2HWR7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:59:05 -0400
Date: Thu, 23 Aug 2012 13:59:01 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 0/9] extended fdinfo via procfs series, v7
Message-ID: <20120823175901.GA8591@fieldses.org>
References: <20120823104323.040550004@openvz.org>
 <20120823122318.GD29943@fieldses.org>
 <20120823124427.GD1992@moon>
 <20120823135234.GE29943@fieldses.org>
 <20120823135606.GE1992@moon>
 <20120823152545.GC6923@fieldses.org>
 <20120823170239.GF1992@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823170239.GF1992@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 09:02:39PM +0400, Cyrill Gorcunov wrote:
> On Thu, Aug 23, 2012 at 11:25:45AM -0400, J. Bruce Fields wrote:
> > On Thu, Aug 23, 2012 at 05:56:06PM +0400, Cyrill Gorcunov wrote:
> > > On Thu, Aug 23, 2012 at 09:52:34AM -0400, J. Bruce Fields wrote:
> > > > 
> > > > I don't have any opinion on whether there should be a configuration
> > > > option.  Just want to make sure the cost when it's turned on is still
> > > > taken seriously.
> > > 
> > > I see. So, does the rest of series looks fine for you (except this config
> > > moment)?
> > 
> > You're using the common filehandle code instead of encoding your own
> > from scratch, which was my only serious objection.
> > 
> 
> Wait, Bruce, now I'm confused, if I understand all correctly
> using common filehandle code from exportfs is preferred,

Right, that's what I meant, sorry if I was unclear.

--b.

> or
> not? What you mean by "encoding your own from scratch"? Could
> you please clarify?
> 
> > I haven't reviewed the rest of it carefully.
> 
> ok
> 
> 	Cyrill
