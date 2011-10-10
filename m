Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab1JJO74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:59:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab1JJO74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:59:56 -0400
Date: Mon, 10 Oct 2011 16:59:53 +0200
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, NamJae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] udf: Convert printks to pr_<level>
Message-ID: <20111010145953.GC3944@quack.suse.cz>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
 <cover.1318233879.git.joe@perches.com>
 <2eb3e996c9fd511f4c3dbf6f26efa3481b70a87a.1318233879.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eb3e996c9fd511f4c3dbf6f26efa3481b70a87a.1318233879.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10-10-11 01:08:05, Joe Perches wrote:
> Use the current logging styles.
> 
> Convert a few printks that should have been udf_warn and udf_err.
> Coalesce formats.  Add #define pr_fmt.
> Move an #include "udfdecls.h" above other includes in udftime.c
> so pr_fmt works correctly.  Strip prefixes from conversions as appropriate.
> Reorder logging definitions in udfdecl.h
  Any reason why you didn't use udf_err() / udf_warn() in all the places
where sb pointer is available? Also I'd further use udf_err() in
udf_parse_options() - passing sb there is simple and additional information
in the message is useful. Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
