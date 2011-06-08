Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1FHNam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:30:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1FHNak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:30:40 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=XYJHFtupD_QA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=SZqOXIthU9N7Ez_25wQA:9 a=0oz2n8WfHEC9MGw72IcA:7 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 8 Jun 2011 09:30:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, david@lang.hm,
        linux-kernel@vger.kernel.org
Subject: Re: XFS problem in 2.6.32
Message-ID: <20110608133037.GF27245@home.goodmis.org>
References: <4DEE1D96.6020208@profihost.ag>
 <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu>
 <4DEE2C70.8060301@profihost.ag>
 <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm>
 <4DEE9EDA.90001@profihost.ag>
 <C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 11:28:59PM -0400, Theodore Tso wrote:

Ted, you need a new MUA, as it reads horribly in mutt.

> 
> Not all distributions will participate in the maintenance stable tree.  Red Hat for example is probably worried about people  (specifically, Oracle) taking their kernel expertise "for free" and bidding it against them.  So it doesn't surprise me that they aren't submitting patches to the stable tree.  After all, they would like you to purchase a support contract if you want to get high quality, supported kernel.   Why should they give that work away for free?  After all, their salaried developers have to get paid somehow.  Others will contribute work in the hopes that other people will also contribute fixes back, but of course nothing forces Red Hat to do this.
> 

As a Red Hat employee, I must speak against this. I have *never* been
told to keep something from stable. In fact, I've always been encouraged
to push to stable. But it is usually the individual engineer's
responsibility to get a patch into stable. If something was missed, it
was more the fault of that individual engineer that made the fix than
Red Hat.

Ask Greg, I'm constantly sending stable patches to him.

-- Steve

