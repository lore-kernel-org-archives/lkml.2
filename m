Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2CVSdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:33:32 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58094 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255Ab2CVSd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:33:28 -0400
Date: Thu, 22 Mar 2012 13:33:34 -0500
From: Ben Myers <bpm@sgi.com>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: elder@kernel.org, xfs-master@oss.sgi.com, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: xfs: fix section mismatch in linux-next
Message-ID: <20120322183334.GN8451@sgi.com>
References: <1331922978-28572-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331922978-28572-1-git-send-email-dev@snitselaar.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 11:36:18AM -0700, Gerard Snitselaar wrote:
> xfs_qm_exit() is called in init_xfs_fs().
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>

Thanks Gerard.
Reviewed-by: Ben Myers <bpm@sgi.com>

