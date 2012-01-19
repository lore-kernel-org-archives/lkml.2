Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2ASKLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:11:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab2ASKLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:11:38 -0500
Date: Thu, 19 Jan 2012 05:11:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] cfq: don't register propio policy if
 !CONFIG_CFQ_GROUP_IOSCHED
Message-ID: <20120119101132.GB2649@redhat.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326935490-11827-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 05:11:20PM -0800, Tejun Heo wrote:
> cfq has been registering zeroed blkio_poilcy_cfq if CFQ_GROUP_IOSCHED
> is disabled.  This fortunately doesn't collide with blk-throtl as
> BLKIO_POLICY_PROP is zero but is unnecessary and risky.  Just don't
> register it if not enabled.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>

Thanks. Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

