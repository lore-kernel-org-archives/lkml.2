Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1ESLEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:04:21 -0400
Received: from verein.lst.de ([213.95.11.211]:45489 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab1ESLET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:04:19 -0400
Date: Thu, 19 May 2011 13:04:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: josef@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] SEEK_DATA/HOLE on ocfs2 - v2
Message-ID: <20110519110419.GA6357@lst.de>
References: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 07:44:42PM -0700, Sunil Mushran wrote:
> It is improved since the last post. It runs cleanly on zfs, ocfs2 and ext3
> (default behavior). Users testing on zfs will need to flip the values of
> SEEK_HOLE/DATA.

sounds like we should switch the around, just to cause the least
amount of confusion.

