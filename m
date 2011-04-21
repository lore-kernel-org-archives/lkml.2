Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1DUUxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:53:37 -0400
Received: from trent.utfs.org ([194.246.123.103]:45470 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab1DUUxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:53:36 -0400
Date: Thu, 21 Apr 2011 13:53:34 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Jens Axboe <jaxboe@fusionio.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Michael Guntsche <mike@it-loops.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        622352@bugs.debian.org, ralf.hildebrandt@charite.de
Subject: Re: 2.6.39 Block layer regression was [Bug] Boot hangs with
 2.6.39-rc[123]]
In-Reply-To: <4DB07942.20209@fusionio.com>
Message-ID: <alpine.DEB.2.01.1104211347380.18728@trent.utfs.org>
References: <20110415035451@it-loops.com> <BANLkTi=50A4f_d0a0oESd3DMMaK1za5BWg@mail.gmail.com> <20110415042255.GC27928@infradead.org> <4DA7E202.4000307@fusionio.com> <alpine.DEB.2.01.1104211051490.18728@trent.utfs.org> <BANLkTim7SLt6TMqJQw35=tnACax0mE1URA@mail.gmail.com>
 <4DB077AF.7020909@nerdbynature.de> <4DB07942.20209@fusionio.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011 at 20:36, Jens Axboe wrote:
> Please try Linus -git as of now, it could be the excessive udev events
> for media change that is causing your problem.

I'm running latest -git (91e8549..), which includes your for-linus branch 
and it's running fine so far (1h:30min uptime).

@Ralf: can you try this as well, maybe it'll fix #622352 for you too?

Thanks,
Christian.
-- 
BOFH excuse #382:

Someone was smoking in the computer room and set off the halon systems.
