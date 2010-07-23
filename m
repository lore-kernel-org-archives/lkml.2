Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab0GWM4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:56:46 -0400
Received: from THUNK.ORG ([69.25.196.29]:45928 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709Ab0GWM4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:56:44 -0400
Date: Fri, 23 Jul 2010 08:56:39 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 26/36] fs/ext4: Remove unnecessary casts of private_data
Message-ID: <20100723125639.GB13090@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
References: <cover.1278967120.git.joe@perches.com>
 <57404f1380cc8d0609b5bd7ce178a8e9eddd2a06.1278967121.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57404f1380cc8d0609b5bd7ce178a8e9eddd2a06.1278967121.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 01:50:18PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/ext4/dir.c     |    2 +-
>  fs/ext4/mballoc.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Thanks, applied to the ext4 tree.

					- Ted
