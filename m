Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2AUWfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 17:35:23 -0500
Received: from trent.utfs.org ([194.246.123.103]:43993 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2AUWfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 17:35:22 -0500
Date: Sat, 21 Jan 2012 14:35:18 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Jens Axboe <axboe@kernel.dk>
cc: LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        dm-devel@redhat.com
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
In-Reply-To: <4F1AB392.20604@kernel.dk>
Message-ID: <alpine.DEB.2.01.1201211430340.2895@trent.utfs.org>
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org> <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org> <4F1AB392.20604@kernel.dk>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jan 2012 at 13:46, Jens Axboe wrote:
> Can you try and pull:
> 
> git://git.kernel.dk/linux-block.git for-linus
> 
> and see if it helps?

Pulled, compiled, bootet - but the BUG: stays. Please see .config and full 
dmesg: http://nerdbynature.de/bits/3.2.0/   (the 3.3.0-rc1 files)

Note that I don't have an actual problem here: the machine (PowerBook G4) 
is booting & running fine, I'm currently not using any LVM devices, so 
it's merely the BUG: being printed during bootup I'm whining about.

Thanks,
Christian.
-- 
BOFH excuse #292:

We ran out of dial tone and we're and waiting for the phone company to deliver another bottle.
