Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0IQNoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:44:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42546 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab0IQNoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:44:21 -0400
Date: Fri, 17 Sep 2010 09:44:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jens@suse.cz,
        "Axboe <axboe"@kernel.dk, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] BDI handling fixes
Message-ID: <20100917134418.GA22737@infradead.org>
References: <1284677051-28564-1-git-send-email-jack@suse.cz>
 <20100916234742.GA26030@infradead.org>
 <20100917125245.GA3342@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917125245.GA3342@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 02:52:45PM +0200, Jan Kara wrote:
>   Agreed. I just think that I'll first make the flags right and then just
> mechanically flip NO_WRITEBACK and WRITEBACK...

Okay, go with the minimal version for now and I'll sort it out later.

