Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511Ab2BJQJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:09:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab2BJQJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:09:50 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Generic O_SYNC AIO DIO handling
References: <1328889842-23231-1-git-send-email-jack@suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 10 Feb 2012 11:09:09 -0500
In-Reply-To: <1328889842-23231-1-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Fri, 10 Feb 2012 17:03:58 +0100")
Message-ID: <x49aa4qpt5m.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hi Jeff,
>
>   these patches implement generic way of handling O_SYNC AIO DIO. They work
> for all filesystems except for ext4 and xfs. Thus together with your patches,
> all filesystems should handle O_SYNC AIO DIO correctly. I've tested ext3,
> btrfs, and xfs (to check that I didn't break anything when the generic code
> is unused) and things seem to work fine. Will you add these patches to your
> series please? Thanks.

Thanks, Jan!  I'll add them in and give them some testing.  I should be
ready to repost the series early next week.

Cheers,
Jeff
