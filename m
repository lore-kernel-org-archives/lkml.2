Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0JNKY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:24:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:44454 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab0JNKYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:24:25 -0400
Date: Thu, 14 Oct 2010 12:23:26 +0200
From: Jan Kara <jack@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jiri Kosina <trivial@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd: Fix debug message in do_get_write_access()
Message-ID: <20101014102326.GC3482@quack.suse.cz>
References: <1286979247-7721-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286979247-7721-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 13-10-10 23:14:07, Namhyung Kim wrote:
> 'buffer_head' should be 'journal_head'.
  Thanks. Merged.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
