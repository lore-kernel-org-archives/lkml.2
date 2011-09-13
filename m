Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1IMPHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:07:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:37960 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1IMPHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:07:47 -0400
Date: Tue, 13 Sep 2011 17:07:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
In-Reply-To: <20110913211154.fe53ca8c1d608def77a69022@canb.auug.org.au>
Message-ID: <alpine.LFD.2.02.1109131706410.2723@ionos>
References: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au> <4E5690C3.2050706@goop.org> <4E5693DD.2010307@zytor.com> <20110826090619.7588d424798f53a6f3621eb2@canb.auug.org.au> <4E56D6E1.6030405@zytor.com> <20110826125441.709aa423cdf072ce085fb91c@canb.auug.org.au>
 <20110913211154.fe53ca8c1d608def77a69022@canb.auug.org.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Sep 2011, Stephen Rothwell wrote:
> Hi,
> 
> On Fri, 26 Aug 2011 12:54:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Thu, 25 Aug 2011 16:12:33 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
> > >
> > > On 08/25/2011 04:06 PM, Stephen Rothwell wrote:
> > > >>
> > > >> Stephen: the x86/spinlocks branch in the -tip tree is obsolete and
> > > >> should be dropped.
> > > > 
> > > > That's a bit tricky as I get a rolled up tip tree.  The best I could do
> > > > is revert the commit that merges the x86/spinlocks branch into
> > > > auto-latest ...  I'll do that for today (unless something happens to the
> > > > tip tree in the next hour).
> > > > 
> > > 
> > > OK, let me bother Ingo about it.
> > 
> > For today, I have done "git revert -m 1 6f8fa39c81f1" after merging the
> > tip tree.
> 
> I am still doing this in each linux-next, and it doesn't appear to have
> been fixed up the the tree on tesla.tglx.de, yet, I think.

We'll take it out. Thanks,

      tglx


