Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab0ITV23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:28:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:58121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab0ITV22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:28:28 -0400
Date: Mon, 20 Sep 2010 23:27:38 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3 RESEND] BDI handling fixes
Message-ID: <20100920212738.GA14020@quack.suse.cz>
References: <1284997471-9850-1-git-send-email-jack@suse.cz>
 <4C979896.6050900@kernel.dk>
 <4C9798D1.9060009@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9798D1.9060009@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-09-10 19:24:33, Jens Axboe wrote:
> On 2010-09-20 19:23, Jens Axboe wrote:
> > On 2010-09-20 17:44, Jan Kara wrote:
> >>   Hi,
> >>
> >>   I resend this series because I've messed up Jens' address in the original
> >> posting. Jens, would you please include these fixes in your tree? Thanks.
> >> The series of these three patches fixes the warning in __mark_inode_dirty()
> >> which happens when I do e.g. touch /dev/zero.
> > 
> > Thanks, I'll commit for .37 and tag the for stable.
> 
> Actually, I think they are fine for .36 directly. Agree?
  Yes, I think they should be OK for .36.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
