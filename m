Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1CHTpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:45:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1CHTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:45:40 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=_SwmUG3pykIA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=ByIdwKuej8lqhwltNQgA:9 a=CrzEylRj16iNKTbS8ZEUihbBvcoA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 8 Mar 2011 14:45:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: broonie@opensource.wolfsonmicro.com, joe@perches.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH 05/18] MAINTAINERS: Remove unnecessary
 linux-kernel@vger.kernel.org entries
Message-ID: <20110308194538.GA8002@home.goodmis.org>
References: <cover.1298439175.git.joe@perches.com>
 <03b0dc89c5badbc0b8f155ecdd5912cad3e278f2.1298439175.git.joe@perches.com>
 <20110301112038.GA12568@sirena.org.uk>
 <20110301141024.GA9014@gmail.com>
 <20110301141308.GG9662@opensource.wolfsonmicro.com>
 <AANLkTin2++GT3eRcTQeeqcB_1whedAt_0Hn+YY8y=v1s@mail.gmail.com>
 <20110301144712.GA9798@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301144712.GA9798@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 10:47:15PM +0800, Harry Wei wrote:
> > 
> > >      I agree with Joe. I think any patch about kernel should be
> > >      emailed to LKML and other connection ML, as well as maintainers.
> > 
> > You're missing my point.  My point is that removing references to LKML
> > from MAINTAINERS is working against this as it makes it harder for users
> > to work out that they're supposed to do this.
> Maybe you are right.

Perhaps we should just add at the beginning of MAINTAINERS a note that
says something to the effect: "When in doubt, Cc
linux-kernel@vger.kernel.org". And then remove all individual references
to the list.

-- Steve

