Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2IDJzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:55:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab2IDJzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:55:10 -0400
Date: Tue, 4 Sep 2012 11:55:06 +0200
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Subject: Re: [PATCH v2] udf: extent cache implementation for manipulating
 block map
Message-ID: <20120904095506.GA5673@quack.suse.cz>
References: <1346431918-3691-1-git-send-email-linkinjeon@gmail.com>
 <20120903124500.GE21109@quack.suse.cz>
 <CAKYAXd8J09FPCTC-4WwfR+wSCTtfqUq1RYNh0V6=ahH4VsiASA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd8J09FPCTC-4WwfR+wSCTtfqUq1RYNh0V6=ahH4VsiASA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-09-12 16:45:42, Namjae Jeon wrote:
> 2012/9/3, Jan Kara <jack@suse.cz>:
> >> +void udf_clear_extent_cache(struct udf_inode_info *iinfo)
> >> +{
> >> +	if (iinfo->cached_extent.sanity) {
> >> +		brelse(iinfo->cached_extent.epos.bh);
> >> +		memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
> >> +	}
> >> +}
> >> +
> >   I think udf_clear_entent_cache() should take i_extent_cache_lock. Or if
> > you are sure it's not needed, you need a good documentation why.
> Documentation ? I am a little confusing.. It means udf.txt is in
> Documentation/filesystem/ ?
> or comment about clear extent function ?
  I meant in a comment before udf_clear_extent_cache() function...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
