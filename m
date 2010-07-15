Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab0GOPz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:55:28 -0400
Received: from sous-sol.org ([216.99.217.87]:37556 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932900Ab0GOPz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:55:26 -0400
Date: Thu, 15 Jul 2010 08:54:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blkdev: cgroup whitelist permission fix
Message-ID: <20100715155415.GU14017@sequoia.sous-sol.org>
References: <20100604201535.GB8301@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604201535.GB8301@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wright (chrisw@sous-sol.org) wrote:
> The cgroup device whitelist code gets confused when trying to grant
> permission to a disk partition that is not currently open.  Part of
> blkdev_open() includes __blkdev_get() on the whole disk.  This simply
> avoids the cgroup check for the whole disk case when opening a
> partition.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=589662
> 
> Acked-by: Serge E. Hallyn <serue@us.ibm.com>
> Tested-by: Serge E. Hallyn <serue@us.ibm.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>

Andrew, plans to push this on?  Christoph doesn't like the whole of
blockdev whitelisting for good reason, but it's currently in use and
has this bug.

thanks,
-chris
