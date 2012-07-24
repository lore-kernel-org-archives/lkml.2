Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2GXXIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 19:08:18 -0400
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:54629
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2GXXIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 19:08:17 -0400
Date: Tue, 24 Jul 2012 16:08:16 -0700
From: Zach Brown <zab@zabbo.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Ankit Jain <jankit@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Make io_submit non-blocking
Message-ID: <20120724230816.GC6723@lenny.home.zabbo.net>
References: <500E89D1.9010303@suse.de>
 <20120724223110.GQ23387@dastard>
 <20120724225026.GA21691@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724225026.GA21691@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And most importantly block devices, as they are one of the biggest
> use cases of AIO.  With an almost no-op get_blocks callback I can't
> see how this change would provide any gain there.

Historically we'd often see submission stuck waiting for requests.
Tasks often try to submit way more aio than the block layer is happy to
have in flight.

Dunno if that's still a problem these days.

- z
