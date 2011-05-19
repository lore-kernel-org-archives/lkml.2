Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1ESLFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:05:32 -0400
Received: from verein.lst.de ([213.95.11.211]:41525 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab1ESLFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:05:31 -0400
Date: Thu, 19 May 2011 13:05:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: josef@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Implement llseek()
Message-ID: <20110519110531.GB6357@lst.de>
References: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com> <1305773084-19296-3-git-send-email-sunil.mushran@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305773084-19296-3-git-send-email-sunil.mushran@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 07:44:44PM -0700, Sunil Mushran wrote:
> Unwritten (preallocated) extents are considered holes because the file system
> treats reads to such regions in the same way as it does to holes.

How does this work for the case of an unwrittent extent that has been
written to in the pagecache but not converted yet?  Y'know the big data
corruption and flamewar that started all this?

