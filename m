Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0CaOgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:36:55 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35645 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751623Ab0CaOgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:36:53 -0400
Date: Wed, 31 Mar 2010 16:36:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andre Przywara <andre.przywara@amd.com>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: KVM warning about uncertified CPU for SMP for AMD model 2,
	stepping 3
Message-ID: <20100331143640.GB1843@ucw.cz>
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz> <20100331024213.GV20695@one.firstfloor.org> <4BB33C0D.9090808@amd.com> <20100331125135.GW20695@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331125135.GW20695@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-03-31 14:51:35, Andi Kleen wrote:
> > >I guess these warnings could be just disabled. With nearly everyone
> > >using multi-core these days they are kind of obsolete anyways.
> > Well, the warning refers to an old single-core only CPU model. Most of 
> > those were able to run in SMP boards, but only a subset of them was 
> > officially certified to do so (Athlon-MP instead of Athlon-XP).
> 
> Thanks for pointing out the obvious.
> 
> > To avoid complaints about instability of such systems, the warning was 
> > introduced. If you consider these systems still supported, I wouldn't 
> > disable this warning, at least the check should be disabled only if the 
> > hypervisor CPUID bit is set.
> 
> The point was that everyone can have a multi-core system for cheap
> these days, no real motivation for anyone anymore to use old unsupported
> configurations to get one.

It still seems better to fix kvm to emulate smp-capable cpu...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
