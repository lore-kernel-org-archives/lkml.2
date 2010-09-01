Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0IASOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 14:14:07 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:6788 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714Ab0IASOG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 14:14:06 -0400
Date: Wed, 1 Sep 2010 19:13:41 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Message-ID: <20100901181341.GA11861@deepthought>
References: <201008312153.45792.Martin@lichtvoll.de> <20100831223921.GA23476@deepthought> <201009011810.31642.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201009011810.31642.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=zzU6Ef89lnMA:10 a=8nJEP1OIZ-IA:10 a=JFx7__YRT1V1ggT0OZ0A:9 a=2EPQNfS7Pjj9lnByI4y0Y5W1A2MA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 06:10:24PM +0200, Martin Steigerwald wrote:
> Am Mittwoch 01 September 2010 schrieb Ken Moffat:
> > 
> >  While you are bisecting, don't believe the version in Makefile.  I
> > got similarly freaked out a couple of years ago - if I understood
> > correctly, it's something to do with when a change was created.
> > 
> >  The key point is that during bisection the apparent version *can*
> > go back to a version that appears to be before the initial "good"
> > kernel.
> 
> I verified the version by running git log after doing the skip. And it was 
> just 300 lines after Linus commited 2.6.33-rc2. Can git log be showing 
> incorrect results during a bisect?
> 
> Thanks,
 I suggest you go with the versions that git bisect selects.

 I appreciate that it takes you a long time to build and test each
kernel, but hopefully you can reach a stage where the bad commit is
identified.

 I think I've seen people report that an old commit was identified
as causing a problem, and I also think that in those cases the
problem was exposed by a later commit.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
