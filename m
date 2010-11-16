Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab0KPAnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 19:43:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:60808 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab0KPAnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 19:43:07 -0500
Date: Tue, 16 Nov 2010 01:43:04 +0100
From: Jan Kara <jack@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alessio Igor Bogani <abogani@texware.it>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] udf: Add missed protection for s_lvid_dirty
Message-ID: <20101116004304.GA31308@quack.suse.cz>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
 <201011152346.41458.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011152346.41458.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-11-10 23:46:41, Arnd Bergmann wrote:
> On Saturday 06 November 2010 18:47:08 Alessio Igor Bogani wrote:
> > As reported in udf_sb.h the udf_sb_infoi's structure member s_lvid_dirty should
> > be protected by s_alloc_mutex. Added that mutex on a couple of places where it
> > miss.
> > 
> > This work was supported by a hardware donation from the CE Linux Forum.
> 
> Any update on this?
> 
> I'd really like to see the BKL disabled by default in 2.6.37, and UDF
> is the final blocker for this now.
  Allesio sent me another version of patches last week and I sent him today
some comments (also told him to CC the list next time). I think the next
iteration should be fine as far as code review is concerned so after some
testing we can merge it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
