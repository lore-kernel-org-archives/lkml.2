Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab2FZOp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:45:26 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43650 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756894Ab2FZOpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:45:25 -0400
Date: Tue, 26 Jun 2012 09:46:59 -0500
From: Ben Myers <bpm@sgi.com>
To: Chen Baozi <baozich@gmail.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix comment typo of xfs_open_devices()
Message-ID: <20120626144659.GR10196@sgi.com>
References: <1340721305-3602-1-git-send-email-baozich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340721305-3602-1-git-send-email-baozich@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 10:35:05PM +0800, Chen Baozi wrote:
> Since "get_sb_bdev()" has been changed to "mount_bdev()", fix
> the comment accordingly.
> 
> Signed-off-by: Chen Baozi <baozich@gmail.com>

Looks good.  Thanks Chen!
Reviewed-by: Ben Myers <bpm@sgi.com>

