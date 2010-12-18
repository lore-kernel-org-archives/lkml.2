Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0LRBPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:15:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756381Ab0LRBPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:15:31 -0500
Date: Fri, 17 Dec 2010 17:14:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCHv6 00/16] pps: several fixes and improvements
Message-Id: <20101217171452.338b0dce.akpm@linux-foundation.org>
In-Reply-To: <20101218040001.7b4a1bc0@apollo.gnet>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<20101217161938.9247e433.akpm@linux-foundation.org>
	<20101218040001.7b4a1bc0@apollo.gnet>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010 04:00:01 +0300
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> __ Fri, 17 Dec 2010 16:19:38 -0800
> Andrew Morton <akpm@linux-foundation.org> __________:
> 
> > On Fri, 17 Dec 2010 22:54:24 +0300
> > Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:
> > 
> > > There is one problem however: kernel consumer works bad (if enabled)
> > > when CONFIG_NO_HZ is enabled. The reason for this is commit
> > > a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601. Without it hardpps() is able
> > > to sync to 1us precision in about 10 seconds. With CONFIG_NO_HZ it is
> > > not syncing at all. This only affects patches 12-14, others are ok.
> > 
> > Is someone working on fixing all this?
> 
> Not right now but it is planned. I can only ensure that users can never
> select CONFIG_NO_HZ and CONFIG_NTP_PPS at the same time. Is it ok?

That's much better than permitting a subtly broken driver.

CONFIG_NO_HZ is pretty common nowadays, methinks.
