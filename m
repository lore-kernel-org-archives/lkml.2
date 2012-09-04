Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab2IDKGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 06:06:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59689 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2IDKGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 06:06:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120904095506.GA5673@quack.suse.cz>
References: <1346431918-3691-1-git-send-email-linkinjeon@gmail.com>
	<20120903124500.GE21109@quack.suse.cz>
	<CAKYAXd8J09FPCTC-4WwfR+wSCTtfqUq1RYNh0V6=ahH4VsiASA@mail.gmail.com>
	<20120904095506.GA5673@quack.suse.cz>
Date: Tue, 4 Sep 2012 19:06:37 +0900
Message-ID: <CAKYAXd9gEu5mAYa9a8GVPC9h8_QnFA=b2vSkWEcUJ2GAWKP8vA@mail.gmail.com>
Subject: Re: [PATCH v2] udf: extent cache implementation for manipulating
 block map
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/4 Jan Kara <jack@suse.cz>:
> On Tue 04-09-12 16:45:42, Namjae Jeon wrote:
>> 2012/9/3, Jan Kara <jack@suse.cz>:
>> >> +void udf_clear_extent_cache(struct udf_inode_info *iinfo)
>> >> +{
>> >> +  if (iinfo->cached_extent.sanity) {
>> >> +          brelse(iinfo->cached_extent.epos.bh);
>> >> +          memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
>> >> +  }
>> >> +}
>> >> +
>> >   I think udf_clear_entent_cache() should take i_extent_cache_lock. Or if
>> > you are sure it's not needed, you need a good documentation why.
>> Documentation ? I am a little confusing.. It means udf.txt is in
>> Documentation/filesystem/ ?
>> or comment about clear extent function ?
>   I meant in a comment before udf_clear_extent_cache() function...
Okay, I understood.
Thanks a lot.
>
>                                                                         Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
