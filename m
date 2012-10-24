Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab2JXKjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:39:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39819 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2JXKjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:39:45 -0400
Date: Wed, 24 Oct 2012 14:39:41 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, xemul@parallels.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch added
 to -mm tree
Message-ID: <20121024103941.GG30983@moon>
References: <20121023220300.1185C200057@hpza10.eem.corp.google.com>
 <20121024084515.GB30983@moon>
 <20121024204746.8a8c0fa14b6495b5d5013db4@canb.auug.org.au>
 <20121024095959.GA30240@moon>
 <20121024212620.da7147354d523151c97de962@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024212620.da7147354d523151c97de962@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 09:26:20PM +1100, Stephen Rothwell wrote:
> > Hi Stephen, could you please elaborate, which bad usage hiding could be there?
> 
> I though it might suppress a warning if someone added an entry with a >2
> character string, but testing shows that it does not, so that is OK.
> There is still no need for the cast, though, or the second set of
> braces.  The C standard allows fixed length char arrays to be initialised
> by string constants and discards the trailing NUL if necessary.

OK, fair enough. I'll post a new patch with all concerns fixed in one
pass. Thanks all for comments!
