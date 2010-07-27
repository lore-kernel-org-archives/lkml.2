Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0G0RR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:17:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:45470 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0G0RR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:17:56 -0400
Date: Tue, 27 Jul 2010 19:17:30 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] bdi: Initialize noop_backing_dev_info properly
Message-ID: <20100727171729.GD6820@quack.suse.cz>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
 <1280250301-17603-4-git-send-email-jack@suse.cz>
 <20100727170939.GB9034@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727170939.GB9034@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-07-10 13:09:39, Christoph Hellwig wrote:
> On Tue, Jul 27, 2010 at 07:05:01PM +0200, Jan Kara wrote:
> > Properly initialize this backing dev info so that writeback code does not
> > barf when getting to it e.g. via sb->s_bdi.
> 
> When do we actually get it in s_bdi?  That should never happen.
  Well, set_anon_super() sets it. I'm not sure if filesystems using this
are supposed to reset it to something else or not... It's a bit messy and
nowhere is actually written how things should be. One can just guess ;)


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
