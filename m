Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab0K3AEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:04:10 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:31014 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754606Ab0K3AEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:04:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG/L80x5LcIv/2dsb2JhbACjCnLCT4VHBA
Date: Tue, 30 Nov 2010 11:04:06 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: maciej.rutecki@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: 2.6.37-rc3-git4 bad desktop performance
Message-ID: <20101130000406.GB3255@amd>
References: <AANLkTimjMR4wUYCfi7BoUcg6aBmuWcQW_dBo8svReWcS@mail.gmail.com>
 <201011281621.59036.maciej.rutecki@gmail.com>
 <AANLkTi=2O80uDo4DvjVj14Q0DGqTcZMQmnd-q2XV6f4K@mail.gmail.com>
 <AANLkTikCt+OB6bq-7Kam40uo=-8Nt-fTa-_o0h835kkN@mail.gmail.com>
 <AANLkTi=ERtG5spFqKH0Xc7JXKrM=YEwyrkb6RsdNbmKH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=ERtG5spFqKH0Xc7JXKrM=YEwyrkb6RsdNbmKH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 04:04:56PM +0200, Anca Emanuel wrote:
> Ups, false alarm, sorry. (wrong git tree)
> 
> I can reproduce this only with:
> git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> vfs-scale-working

What performance is bad? Anything in dmesg? Can you bisect the vfs scale
git tree patches?

