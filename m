Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935151Ab1JERwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:52:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53010 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab1JERwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:52:40 -0400
Date: Wed, 5 Oct 2011 11:52:35 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/3] gpio-ml-ioh: Fix suspend/resume issue
Message-ID: <20111005175235.GC4205@ponder.secretlab.ca>
References: <1312517062-5582-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1312517062-5582-3-git-send-email-tomoya-linux@dsn.okisemi.com>
 <20111004160731.GA9084@ponder.secretlab.ca>
 <4E8BB327.50306@dsn.lapis-semi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8BB327.50306@dsn.lapis-semi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 10:30:15AM +0900, Tomoya MORINAGA wrote:
> Hi Grant,
> 
> (2011/10/05 1:07), Grant Likely wrote:
> >On Fri, Aug 05, 2011 at 01:04:22PM +0900, Tomoya MORINAGA wrote:
> >Can this one be merged without 1/3 and 2/3?  Patch 2 looks like a
> >feature instead of a bug fix.
> >
> 
> Is the above true ?
> I think,
> 1/3 is a bug fix.
> 2/3 and 3/3 are feature.

Considering that the title of 3/3 is "Fix suspend/resume issue", you
can understand my confusion.  I'm not talking about 1/3 because it
looks like a trivial cleanup (not a bug fix).

> Do you mean you will merge only patch for a bug fix ?
> What will you do feature patch ?

I'll merge them regardless, I just need to know which branch to merge
them in.  If patch 3 is a bug fix independent of patches 1 & 2, then
I'll put it in spi/merge and ask Linus to pull right away.  Otherwise
I'll put it in spi/next along with patches 1 & 2.

g.

