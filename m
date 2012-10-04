Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2JEBay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 21:30:54 -0400
Received: from plane.gmane.org ([80.91.229.3]:41492 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021Ab2JEBaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 21:30:52 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el.es.cr@gmail.com>
Subject: Re: The 10ms averager in fair.c + granularity
Date: Thu, 4 Oct 2012 12:20:17 +0000 (UTC)
Message-ID: <loom.20121004T135715-721@post.gmane.org>
References: <op.wlf5j0i76426ze@localhost.localdomain> <1349064397.6957.26.camel@marge.simpson.net> <op.wlh4u2xj6426ze@millennium.getinternet.no> <1349146202.7086.23.camel@marge.simpson.net> <op.wllzacy16426ze@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 86.171.78.167 (Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20100101 Firefox/15.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Uwaysi,

Uwaysi Bin Kareem <uwaysi.bin.kareem <at> paradoxuncreated.com> writes:

> 
> Ok at 100hz, granularity seems to work as expected. Actually 1000hz for  
> desktop seems to be a myth. I have less jitter with 100hz. Very nice. I  
> think jitter is 99.99% eliminated from doom 3 now.
> 
> Peace Be With You!
> 

I think for some real credibility you'd have to come up with a 
(synthetic) benchmark that clearly demonstrates this problem...

/This/ seems to be the /real/ problem here: how do you measure generic
jitter? In hard figures, not just 'theoretically'.

And no, the subjective 'I can feel it' doesn't work, as everybody
has a different perception of 'jitter', especially in opengl....

Maybe try to match the 'filter' avg timing to your gfx screen refresh rate?
(15ms for 60Hz, you get the idea?) and tell us how that works?

Lukasz



