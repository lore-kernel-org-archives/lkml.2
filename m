Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1C3JM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:12:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42144 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab1C3JMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:12:55 -0400
Date: Wed, 30 Mar 2011 10:12:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: fix build failure introduced by typo in irq
	namespace cleanup.
Message-ID: <20110330091230.GB29121@n2100.arm.linux.org.uk>
References: <20110330060229.27397.7628.stgit@ponder> <alpine.LFD.2.00.1103301107020.22418@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103301107020.22418@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:08:07AM +0200, Thomas Gleixner wrote:
> On Wed, 30 Mar 2011, Grant Likely wrote:
> 
> > Commit 6845664a6a7d443f03883db59d10749d38d98b8e, "arm: Cleanup the irq
> > namespace" introduces a typo causing a build failure for the versatile
> > platform.
> 
> Sorry about that. I have no clue how I fatfingered that in last
> minute.
> 
> rmk: are you picking it up or should I push it linuswards with the
> other fixups ?

If you have other fixes which you're already sending, you might as well
include those.  Linus hasn't pulled my stuff from last night so I'm not
touching my tree today.
