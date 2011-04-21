Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1DURxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:53:53 -0400
Received: from trent.utfs.org ([194.246.123.103]:58684 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1DURxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:53:51 -0400
Date: Thu, 21 Apr 2011 10:53:47 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Jens Axboe <jaxboe@fusionio.com>
cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Guntsche <mike@it-loops.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39 Block layer regression was [Bug] Boot hangs with
 2.6.39-rc[123]]
In-Reply-To: <4DA7E202.4000307@fusionio.com>
Message-ID: <alpine.DEB.2.01.1104211051490.18728@trent.utfs.org>
References: <20110415035451@it-loops.com> <BANLkTi=50A4f_d0a0oESd3DMMaK1za5BWg@mail.gmail.com> <20110415042255.GC27928@infradead.org> <4DA7E202.4000307@fusionio.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011 at 08:13, Jens Axboe wrote:
> I think we are done, Neil just needs to rebase around the current
> for-linus and then we should expedite things in.

Whatever this was: has it been pushed to Linus yet? I'm on 2.6.39-rc4+ 
(from yesterday) and I too experience a hang during boot (and other 
strange things with udev[0])

Thanks,
Christian.

[0] http://nerdbynature.de/bits/2.6.39-rc4/
-- 
BOFH excuse #208:

Your mail is being routed through Germany ... and they're censoring us.
