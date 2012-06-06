Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2FFGSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:18:10 -0400
Received: from trent.utfs.org ([94.185.90.103]:45258 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab2FFGSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:18:09 -0400
Date: Tue, 5 Jun 2012 23:17:49 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Matt Carlson <mcarlson@broadcom.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: tg3: transmit timed out, resetting
In-Reply-To: <20120606010255.GA9991@mcarlson.broadcom.com>
Message-ID: <alpine.DEB.2.01.1206052314340.5568@trent.utfs.org>
References: <alpine.DEB.2.01.1206041546070.5568@trent.utfs.org> <20120606010255.GA9991@mcarlson.broadcom.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012 at 18:02, Matt Carlson wrote:
> I'm attempting to reproduce this in our lab.  In the meantime, 
> the latest revisions of the driver output a register dump and some
> additional information when transmit timeouts happen.  It would be
> useful to see that data.

I've only copied so much of the warning into my initial email, but after 
that, much more followed, which looks like a register dump. I've put 
everything (the whole logs and more) here:

  http://nerdbynature.de/bits/3.4.0/tg3/

Is that what you're looking for?

> Would it be possible to try a the latest kernels and get this information?

I've observed this with 3.4, but I'll update to latest 3.5-git tomorrow 
and let you know.

Thanks for replying,
Christian.
-- 
BOFH excuse #192:

runaway cat on system.
