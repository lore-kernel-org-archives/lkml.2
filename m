Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1JJRrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:47:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1JJRri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:47:38 -0400
Date: Mon, 10 Oct 2011 19:47:36 +0200
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, NamJae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] udf: Change some KERN_<level>s and logging
 neatening
Message-ID: <20111010174735.GK3944@quack.suse.cz>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
 <cover.1318233879.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1318233879.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10-10-11 01:08:01, Joe Perches wrote:
> I reviewed your patch and think it's too large
> for others to review because it combines multiple
> things into a single patch.
> 
> I think that adding struct super_block * to udb_debug
> isn't necessary or particularly useful.
> 
> Here are the changes to your original patch that I made:
> 
> Separate a single large patch into reviewable chunks.
> Don't convert every message type to udf_<foo>.
> 
> Joe Perches (6):
>   udf: Promote some debugging messages to udf_error
>   udf: Rename udf_error to udf_err
>   udf: Rename udf_warn to udf_warn
>   udf: Convert printks to pr_<level>
>   udf: Neaten logging output, use vsprintf extension %pV
>   udf: Neaten udf_debug uses
  So, I've merged all the patches (patches 1, 4, and 5 with some
modifications). Since kernel.org where I normally have my tree is down
(well, better said I have not reestablished my tree there yet), I'll resend
the whole series in a while so that people see what I carry.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
