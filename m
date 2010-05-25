Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab0EYRVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:21:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0EYRVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:21:11 -0400
Date: Tue, 25 May 2010 13:21:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Will Drewry <wad@chromium.org>
Cc: Alasdair G Kergon <agk@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>, Tejun Heo <tj@kernel.org>,
       Scott James Remnant <scott@ubuntu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Harald Hoyer <harald@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, snitzer@redhat.com
Subject: Re: [PATCH 2/2] init, mount: export the name_to_dev_t symbol
Message-ID: <20100525172110.GA6046@infradead.org>
References: <1274802411-26613-1-git-send-email-wad@chromium.org> <1274802411-26613-2-git-send-email-wad@chromium.org> <20100525155535.GA811@infradead.org> <20100525160550.GC28588@agk-dp.fab.redhat.com> <AANLkTin6Nt2TqxlF9kQJZThI7pZ6wqAwSlg9GnqkKB-v@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin6Nt2TqxlF9kQJZThI7pZ6wqAwSlg9GnqkKB-v@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 11:11:33AM -0500, Will Drewry wrote:
> In addition to getting rid of the code duplication, I'd like device-mapper
> to be able to resolve slave devices at boot-time to accommodate a
> do_mounts_dm.c equivalent to do_mounts_md.c:

So please add a do_mounts_dm.c instead of pushing this somewhere it
doesn't belong to.

