Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab1EBEg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 00:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1EBEgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 00:36:54 -0400
Date: Mon, 2 May 2011 00:36:43 -0400
From: Dave Jones <davej@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
Message-ID: <20110502043642.GD11804@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <20110502121817.645d544e.sfr@canb.auug.org.au>
 <20110502022417.GA11804@redhat.com>
 <20110502134524.40da4245.sfr@canb.auug.org.au>
 <20110502142454.a7091ad5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502142454.a7091ad5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 02:24:54PM +1000, Stephen Rothwell wrote:
 > Hi Dave,
 > 
 > On Mon, 2 May 2011 13:45:24 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
 > >
 > > On Sun, 1 May 2011 22:24:18 -0400 Dave Jones <davej@redhat.com> wrote:
 > > >
 > > > Which version of the patch got merged ? This should be guarded by cc-option checks.
 > > 
 > > It looks right to me (that's why I wrote "though I don't see why") but
 > > empirically we have a problem.
 > 
 > I do not get it for every compile fo a file, just a few times during a
 > whole kernel build.  Some config/arches do not produce any (like sparc32
 > defconfig).
 
That's interesting. That suggests that something isn't being built with KBUILD_CFLAGS.
I did a full defconfig build on x86-64 successfully (allmodconfig is churning away).
Can you point me at something that doesn't build ?

	Dave
