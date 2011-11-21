Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1KUBRO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 20:17:14 -0500
Received: from trent.utfs.org ([194.246.123.103]:42394 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab1KUBRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 20:17:11 -0500
Date: Sun, 20 Nov 2011 17:17:07 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: 3.2.0-rc1 panic on PowerPC
In-Reply-To: <1321837101.13860.6.camel@pasglop>
Message-ID: <alpine.DEB.2.01.1111201701000.8000@trent.utfs.org>
References: <alpine.DEB.2.01.1111150035560.8000@trent.utfs.org>  <alpine.DEB.2.01.1111201529070.8000@trent.utfs.org> <1321837101.13860.6.camel@pasglop>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 at 11:58, Benjamin Herrenschmidt wrote:
> I've seen something similar with 3.2-rc2 at cfcfc9ec, unfortunately I
> couldn't capture the oops log at the time.

It just happened again today, after heavy CPU & IO load (rsyncing from/to 
external disks on dm-crypt). This time the oops was printed on the screen 
but nothing on netconsole:

http://nerdbynature.de/bits/3.2.0-rc1/oops/oops3m.JPG

It looks like the oops I reported earlier (oops2m.JPG) so I doubt it's a 
random corruption due to hardware issues...?

Any debug or boot options to set in my next kernel build?

Thanks,
Christian.

> Looks like there's some kind of memory corruption happening. So far I
> haven't been able to get a good target at what could be causing it.

-- 
BOFH excuse #90:

Budget cuts
