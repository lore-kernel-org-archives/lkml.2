Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1E1U4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 16:56:42 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:36826 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751922Ab1E1U4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 16:56:39 -0400
Date: Sat, 28 May 2011 21:56:38 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: MIPS panic in 2.6.39 (bisected to 7eaceaccab5f)
Message-ID: <20110528205638.GA20010@linux-mips.org>
References: <4DDB5673.5060206@landley.net>
 <20110524143937.GB30117@linux-mips.org>
 <4DDCB1EB.4020707@landley.net>
 <20110527075512.GE30117@linux-mips.org>
 <20110527140011.GF30117@linux-mips.org>
 <4DE0D303.8000106@landley.net>
 <20110528162807.GB7150@linux-mips.org>
 <4DE15373.8050708@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE15373.8050708@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 02:56:35PM -0500, Rob Landley wrote:

> > Thanks Rob!  I fixed that and the patch is now in the MIPS git.
> > 
> >   Ralf
> 
> Do you think it's a candidate for stable?

I'm afraid so it is indeed.  I copied the patch to the -stable branch
right away.

  Ralf
