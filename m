Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0KOLhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:37:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39078 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0KOLhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:37:41 -0500
Date: Mon, 15 Nov 2010 12:37:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org,
        Jim Bos <jim876@xs4all.nl>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115113739.GH7269@basil.fritz.box>
References: <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
 <20101109134816.GB29433@basil.fritz.box>
 <m3lj52txaq.fsf@redhat.com>
 <4CD97A3D.1040602@xs4all.nl>
 <m31v6nmmr3.fsf@jhcloos.com>
 <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
 <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
 <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
 <20101115105446.GD7269@basil.fritz.box>
 <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Guess we need somebody who actually reported the problem, state what
> gcc was actually used and post preprocessed source, gcc options
> from his case.

Jim Bos,
Can you please supply that? 

Please use 

rm drivers/char/i8k.o
make V=1 drivers/char/i8k.o
make drivers/char/i8k.i  

and supply the .i file and the output of the first make line

Thanks,
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
