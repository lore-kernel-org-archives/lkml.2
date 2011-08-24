Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1HXEej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:34:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63326 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1HXEeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:34:37 -0400
Subject: Re: linux next: Native Linux KVM tool inclusion request
From: Sasha Levin <levinsasha928@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-next@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20110824115233.4b515a6ceee8910e9c21fc50@canb.auug.org.au>
References: <1314044960.3668.9.camel@lappy>
	 <20110824115233.4b515a6ceee8910e9c21fc50@canb.auug.org.au>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 24 Aug 2011 07:33:11 +0300
Message-ID: <1314160391.3449.0.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 11:52 +1000, Stephen Rothwell wrote:
> Hi Sasha,
> 
> On Mon, 22 Aug 2011 23:29:20 +0300 Sasha Levin <levinsasha928@gmail.com> wrote:
> >
> > I would like to ask you to include the Native Linux KVM tool in the
> > linux-next tree.
> > 
> > The branch is named 'master' and is located in:
> > 
> > 	git://github.com/penberg/linux-kvm.git
> 
> I have included your tree from today and called it "kvmtool". I have you
> and Pekka currently listed as teh contacts (since it looks like it is his
> tree on github).  Please consider adding a MAINTAINERS entry for this.
> 
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window. 
> 
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
> 	Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and 
>      * destined for the current or next Linux merge window.
> 
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.
> 

Thank you for the inclusion.

We will add a MAINTAINERS file.

-- 

Sasha.

