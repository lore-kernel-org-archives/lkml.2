Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab0E0FOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:14:38 -0400
Received: from ist.d-labs.de ([213.239.218.44]:48002 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932551Ab0E0FOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:14:35 -0400
Date: Thu, 27 May 2010 07:14:29 +0200
From: Florian Mickler <florian@mickler.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527071429.58fa81ac@schatten.dmk.lab>
In-Reply-To: <20100526230943.6f5e5b37@lxorguk.ukuu.org.uk>
References: <20100526171106.0e44a736@schatten.dmk.lab>
	<alpine.LFD.2.00.1005261829540.2995@localhost.localdomain>
	<20100526215409.33296d94@schatten.dmk.lab>
	<20100526230943.6f5e5b37@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 23:09:43 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> We now have suggestions how to do the job properly so the right thing is
> probably to go and explore those suggestions not merge crap.
> 
> Merging crap won't help anyway. The rest of the kernel community can
> still simply stonewall those interfaces, and a volunteer community has
> ways of dealing with abuse of process, notably by simply not getting
> around to, or implementing things directly contrary to the crap bits.
> 
> So it's not even in the interest of people to play political games. Even
> if you get away with in the short term the people who rely on the junk
> will end up out on a limb and holding the baby when the crap hits the fan
> (see reiserfs)
> 
> Alan

I'm not interested in "abusing processes". I just think, this is in
limbo for too long already.
Just decide something. One way or the other. The world will continue.

Cheers,
Flo
