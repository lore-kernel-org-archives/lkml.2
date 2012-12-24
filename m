Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab2LXIXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 03:23:13 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48942 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab2LXIXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 03:23:10 -0500
Date: Mon, 24 Dec 2012 16:36:37 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 2/3] mm: Update file times when inodes are written
 after mmaped writes
Message-ID: <20121224083637.GA11906@gmail.com>
Mail-Followup-To: Andy Lutomirski <luto@amacapital.net>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <cover.1356124965.git.luto@amacapital.net>
 <6b22b806806b21af02b70a2fa860a9d10304fc16.1356124965.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b22b806806b21af02b70a2fa860a9d10304fc16.1356124965.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 01:28:27PM -0800, Andy Lutomirski wrote:
> The onus is currently on filesystems to call file_update_time
> somewhere in the page_mkwrite path.  This is unfortunate for three
> reasons:
> 
> 1. page_mkwrite on a locked page should be fast.  ext4, for example,
>    often sleeps while dirtying inodes.  (This could be considered a
>    fixable problem with ext4, but this approach makes it
>    irrelevant.)

Hi Andy,

Out of curiosity, could you please share more detailed information about
how to reproduce and measure this problem in ext4?

Thanks
                                        - Zheng
