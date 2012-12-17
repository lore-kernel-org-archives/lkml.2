Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab2LQRA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:00:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab2LQRAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:00:23 -0500
Date: Mon, 17 Dec 2012 09:00:16 -0800
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block IO bits for 3.8
Message-ID: <20121217170016.GA2592@htj.dyndns.org>
References: <50CF3B82.9000904@kernel.dk>
 <x49licwwtm8.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49licwwtm8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:06:39AM -0500, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
> > - Export control of bdi flusher thread CPU mask and default to using the
> >   home node (if known) from Jeff.
> 
> I certainly wouldn't mind this going in, but I think Tejun NACKed this
> patch.  Tejun?

Hmm... yeah, I would much prefer if this doesn't go in this time.  I
think we need something more generic for threadpools w/ scheduling
restrictions.  It would be possible to retrofit so that the interface
eventually matches but given that this feature isn't an immediate
must-have thing, I think it would be better to not do this right now.

Thanks.

-- 
tejun
