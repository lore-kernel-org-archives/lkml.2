Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803Ab1LPVS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 16:18:59 -0500
Received: from relay3.sgi.com ([192.48.152.1]:39405 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760696Ab1LPVSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 16:18:52 -0500
Date: Fri, 16 Dec 2011 15:19:16 -0600
From: Ben Myers <bpm@sgi.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: fix acl count validation in xfs_acl_from_disk()
Message-ID: <20111216211916.GO29840@sgi.com>
References: <1323726952-22963-1-git-send-email-xi.wang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323726952-22963-1-git-send-email-xi.wang@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 04:55:52PM -0500, Xi Wang wrote:
> Commit fa8b18ed didn't prevent the integer overflow and possible
> memory corruption.  "count" can go negative and bypass the check.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>

Looks good.  Nice catch!
Reviewed-by: Ben Myers <bpm@sgi.com>
