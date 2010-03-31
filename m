Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab0CaMvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:51:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45824 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258Ab0CaMvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:51:39 -0400
Date: Wed, 31 Mar 2010 14:51:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andre Przywara <andre.przywara@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: KVM warning about uncertified CPU for SMP for AMD model 2, stepping 3
Message-ID: <20100331125135.GW20695@one.firstfloor.org>
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz> <20100331024213.GV20695@one.firstfloor.org> <4BB33C0D.9090808@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB33C0D.9090808@amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >I guess these warnings could be just disabled. With nearly everyone
> >using multi-core these days they are kind of obsolete anyways.
> Well, the warning refers to an old single-core only CPU model. Most of 
> those were able to run in SMP boards, but only a subset of them was 
> officially certified to do so (Athlon-MP instead of Athlon-XP).

Thanks for pointing out the obvious.

> To avoid complaints about instability of such systems, the warning was 
> introduced. If you consider these systems still supported, I wouldn't 
> disable this warning, at least the check should be disabled only if the 
> hypervisor CPUID bit is set.

The point was that everyone can have a multi-core system for cheap
these days, no real motivation for anyone anymore to use old unsupported
configurations to get one.

-Andi
