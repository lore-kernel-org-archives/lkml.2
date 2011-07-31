Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab1GaSgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 14:36:07 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56351
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790Ab1GaSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 14:35:58 -0400
Date: Sun, 31 Jul 2011 14:35:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sage Weil <sage@newdream.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [GIT PULL] Ceph updates for 3.1-rc1
Message-ID: <20110731183556.GA23133@infradead.org>
References: <Pine.LNX.4.64.1107261152440.2593@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1107261152440.2593@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 01:36:37PM -0700, Sage Weil wrote:
> Sage Weil (19):
>       ceph: add flags field to file_info
>       ceph: add F_SYNC file flag to force sync (non-O_DIRECT) io

Can you document what the exact semantics of this flag are, and how
they different from using O_SYNC/O_DSYNC.

