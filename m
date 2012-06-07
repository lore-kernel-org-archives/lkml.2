Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab2FGHNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 03:13:15 -0400
Received: from trent.utfs.org ([94.185.90.103]:53475 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab2FGHNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 03:13:14 -0400
Date: Thu, 7 Jun 2012 00:13:10 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Matt Carlson <mcarlson@broadcom.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: tg3: transmit timed out, resetting
In-Reply-To: <alpine.DEB.2.01.1206052314340.5568@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1206070002370.5568@trent.utfs.org>
References: <alpine.DEB.2.01.1206041546070.5568@trent.utfs.org> <20120606010255.GA9991@mcarlson.broadcom.com> <alpine.DEB.2.01.1206052314340.5568@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012 at 23:17, Christian Kujau wrote:
> I've only copied so much of the warning into my initial email, but after 
> that, much more followed, which looks like a register dump. I've put 
> everything (the whole logs and more) here:
> 
>   http://nerdbynature.de/bits/3.4.0/tg3/
> 
> Is that what you're looking for?

Have you had a chance looking at those outputs yet?

> > Would it be possible to try a the latest kernels and get this information?

I'm running today's git (3.5.0-rc1-00110-g71fae7e) and ~3.5h after 
booting the same warning was printed, along with the register dump (if 
that's what it is). I've put the full output online again:

    http://nerdbynature.de/bits/3.4.0/tg3/
    - messages_3.5.0-rc1-00110-g71fae7e.txt.gz
    - config_3.5.0-rc1-00110-g71fae7e.gz

Thanks,
Christian.
-- 
BOFH excuse #10:

hardware stress fractures
