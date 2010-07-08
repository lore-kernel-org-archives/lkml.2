Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0GHHMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:12:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54979 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab0GHHMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:12:02 -0400
Date: Thu, 8 Jul 2010 09:11:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Ma, Ling" <ling.ma@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip] Revert x86, mem: Optimize memcpy by avoiding memory
 false dependece
Message-ID: <20100708071153.GH4414@elte.hu>
References: <20100708062733.GA24740@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708062733.GA24740@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2522]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> * Ma, Ling (ling.ma@intel.com) wrote:
> > Hi Mathieu
> > 
> > I did git revert as bellow
> >     Revert "x86, mem: Optimize memcpy by avoiding memory false dependece"
> > 
> >     This reverts commit 77ff5e49c20bb72a99a12bfb00dbf90b2302f087.
> > And I found the machine will crash with your config file
> > 
> > Could you revert the patch : 77ff5e49c20bb72a99a12bfb00dbf90b2302f087 on your
> > machine, and check it again ?
> 
> Hi Ling,
> 
> I just successfully booted my machine 3 times in a row with a revert of 
> commit a1e5278e40f16a4611264f8da9e557c16cb6f6ed from -tip. This is actually 
> the same as reverting commit 77ff5e49c20bb72a99a12bfb00dbf90b2302f087, as 
> a1e5278e40f16a4611264f8da9e557c16cb6f6ed is simply a merge of that commit 
> (the diffs are exactly the same).
> 
> Without this revert, the machine gets to:

Please check latest -tip (2a74852 or later), the commit should be gone now.

There's clearly some (boundary-condition?) bug in the assembly code of 
77ff5e49c2.

Thanks,

	Ingo
