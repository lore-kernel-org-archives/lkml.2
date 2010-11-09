Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0KIUUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:20:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52439 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0KIUUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:20:53 -0500
Date: Tue, 9 Nov 2010 15:20:33 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Evgeniy Ivanov <lolkaantimat@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Sanjoy Mahajan <sanjoy@olin.edu>,
        Steven Barrett <damentz@gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101109202033.GA17122@infradead.org>
References: <AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
 <20101028090002.GA12446@elte.hu>
 <AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
 <20101028133036.GA30565@elte.hu>
 <20101028170132.GY27796@think>
 <alpine.LNX.2.00.1011050032440.16015@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1011050047220.16015@swampdragon.chaosbits.net>
 <20101105014334.GF13830@dastard>
 <alpine.LNX.2.00.1011071753560.26056@swampdragon.chaosbits.net>
 <AANLkTinZCBs_JO0Ug58uJdWEuqx=xzzBn2nJzdYr7+hb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinZCBs_JO0Ug58uJdWEuqx=xzzBn2nJzdYr7+hb@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure if "data=writeback" (makes ext4 journaling similar to
> XFS) really fixes the problem

It doesn't.  XFS does not expose stale data after a crash, while ext3/4
data=writeback does.

