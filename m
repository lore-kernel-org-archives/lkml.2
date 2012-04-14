Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2DNMCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 08:02:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63440 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2DNMCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 08:02:14 -0400
Date: Sat, 14 Apr 2012 14:02:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: NeilBrown <neilb@suse.de>, Jim Kukunas <james.t.kukunas@linux.intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        tglx@linutronix.de, linux-raid@vger.kernel.org
Subject: Re: arch/86: AVX RAID5 xor checksumming
Message-ID: <20120414120208.GI24688@gmail.com>
References: <1334078551-6859-1-git-send-email-james.t.kukunas@linux.intel.com>
 <4F846FBC.9060503@zytor.com>
 <20120411061442.2f839c77@notabene.brown>
 <4F84A40E.8040907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F84A40E.8040907@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 04/10/2012 01:14 PM, NeilBrown wrote:
> >>
> >> I think this (and the SSSE3 patches for RAID-6) should go in via the
> >> RAID tree.  Neil, do you agree?
> > 
> > I'm happy to take the SSSE3 RAID-6 patches as they only affect lib/raid6, but
> > I felt that this one - being purely in arch/x86 - should probably go via the
> > x86 tree.
> > However I'm flexible and if you (collectively) are happy with these patches
> > going in through my tree, I'll do that.
> > 
> 
> Go ahead and take them with my Acked-by: -- I think that's easier.

Yeah - and x86/include/asm/xor*.h should probably be renamed 
raid_xor*.h or so, to make this really obvious to do in the 
future.

Thanks,

	Ingo
