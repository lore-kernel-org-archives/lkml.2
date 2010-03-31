Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab0CaMxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:53:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45832 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab0CaMxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:53:18 -0400
Date: Wed, 31 Mar 2010 14:53:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH][RFC] x86: remove SMP check/taint for AMD K7 (was Re: KVM warning about uncertified CPU for SMP for AMD model 2, stepping 3)
Message-ID: <20100331125317.GX20695@one.firstfloor.org>
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz> <20100331024213.GV20695@one.firstfloor.org> <alpine.LNX.2.00.1003311008270.24576@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1003311008270.24576@pobox.suse.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:15:28AM +0200, Jiri Kosina wrote:
> On Wed, 31 Mar 2010, Andi Kleen wrote:
> 
> > > booting 32bit guest on 32bit host on AMD system gives me the following 
> > > warning when KVM is instructed to boot as SMP:
> > 
> > I guess these warnings could be just disabled. With nearly everyone
> > using multi-core these days they are kind of obsolete anyways.
> 
> Why is it there for K7 only anyway? Was that the only product line which 
> had instances which were explicitly marked as unsuitable for SMP by AMD?

Later ones were fused, so even if you wanted to you couldn't cheat this
way. Earlier CPUs didn't support SMP.

-Andi
