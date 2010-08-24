Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab0HXHnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:43:43 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1383 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128Ab0HXHnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:43:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOIUc0x5Ld90/2dsb2JhbACgPHK5WoU3BA
Date: Tue, 24 Aug 2010 17:43:39 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH,TRIVIAL] Replace Configure with Enable in description
 of MAXSMP
Message-ID: <20100824074339.GG3948@amd>
References: <20100821193241.GB4760@const.famille.thibault.fr>
 <AANLkTi=Pha8jRFhr+kQfh9doKZDW-=VHq2KqNxXaq6ts@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Pha8jRFhr+kQfh9doKZDW-=VHq2KqNxXaq6ts@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 12:45:12PM -0700, Linus Torvalds wrote:
> On Sat, Aug 21, 2010 at 12:32 PM, Samuel Thibault
> <samuel.thibault@ens-lyon.org> wrote:
> >
> > Replace Configure with Enable in description of MAXSMP
> >
> > The "Configure" word tends to make user believe they have to say 'yes'
> > to be able to choose the number of procs/nodes.  "Enable" should be
> > unambiguous enough.
> 
> What broken patch-generation tools do you use, btw? Nick Piggin has
> the same problem: the Subject of the patch gets repeated as the first
> line of the body of the thing, which is very annoying. Either I have
> to go in and edit the email (which I try to do), or the thing gets
> repeated in the commit message.

I'm sorry about that :( I did try applying it here locally which seemed
to work, but something obviously went wrong between then and sending it.


