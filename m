Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab2DYVZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:25:36 -0400
Received: from fieldses.org ([174.143.236.118]:50123 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085Ab2DYVZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 17:25:34 -0400
Date: Wed, 25 Apr 2012 17:25:32 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, swhiteho@redhat.com
Subject: Re: [PATCH 0/6] Get rid of I_MUTEX_QUOTA use
Message-ID: <20120425212532.GB3251@fieldses.org>
References: <1335387467-4928-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335387467-4928-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:57:41PM +0200, Jan Kara wrote:
> 
>   Hello,
> 
>   this patch set changes generic quota code (and filesystems relying on it)
> so that they don't use special locking class I_MUTEX_QUOTA. The only remaining
> user of I_MUTEX_QUOTA is GFS2. If noone has objections, I can merge these
> patches through my tree or Bruce, you can take them as your work depends
> on these changes.

My changes will likely need to go through Al, and depend on GFS2 being
fixed as well.

So it's up to Al.  Best might be to just merge it through your tree and
let us sort it out in the next merge window?

--b.
