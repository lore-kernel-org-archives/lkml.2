Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1CJCIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:08:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52696 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab1CJCHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:07:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=NwbukFywP2VgaAgfg9a43L3JTx3t5fmv6QDcNW83cjTB0v7gMGkXh7bB0U9f3s8xwc
         t4aKcx2f1Ce5WKkO2ujnfbhQQ0wJHTtJU9F9yVrgJRZLpbkej8qAyP/NuryzD+ajc0wn
         +dtb6/EwS026Zsu6EALo8f2F967Gm/y6BToIk=
Date: Thu, 10 Mar 2011 10:07:21 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: broonie@opensource.wolfsonmicro.com, joe@perches.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH 05/18] MAINTAINERS: Remove unnecessary
 linux-kernel@vger.kernel.org entries
Message-ID: <20110310020718.GA2976@gmail.com>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	broonie@opensource.wolfsonmicro.com, joe@perches.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <cover.1298439175.git.joe@perches.com>
 <03b0dc89c5badbc0b8f155ecdd5912cad3e278f2.1298439175.git.joe@perches.com>
 <20110301112038.GA12568@sirena.org.uk>
 <20110301141024.GA9014@gmail.com>
 <20110301141308.GG9662@opensource.wolfsonmicro.com>
 <AANLkTin2++GT3eRcTQeeqcB_1whedAt_0Hn+YY8y=v1s@mail.gmail.com>
 <20110301144712.GA9798@gmail.com>
 <20110308194538.GA8002@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308194538.GA8002@home.goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 02:45:38PM -0500, Steven Rostedt wrote:
> On Tue, Mar 01, 2011 at 10:47:15PM +0800, Harry Wei wrote:
> > > 
> > > >      I agree with Joe. I think any patch about kernel should be
> > > >      emailed to LKML and other connection ML, as well as maintainers.
> > > 
> > > You're missing my point.  My point is that removing references to LKML
> > > from MAINTAINERS is working against this as it makes it harder for users
> > > to work out that they're supposed to do this.
> > Maybe you are right.
> 
> Perhaps we should just add at the beginning of MAINTAINERS a note that
> says something to the effect: "When in doubt, Cc
> linux-kernel@vger.kernel.org". And then remove all individual references
> to the list.
This sounds good. I think we should have a try.
Could i patch for this thought?
Any different idea for us?

Thanks.
Best Regards.
Harry Wei.
> 
> -- Steve
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
