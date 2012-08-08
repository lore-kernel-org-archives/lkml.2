Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab2HHX2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:28:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53823 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2HHX2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:28:10 -0400
Date: Wed, 8 Aug 2012 16:28:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>,
        vgoyal@redhat.com, yehuda@hq.newdream.net, sage@newdream.net,
        agk@redhat.com, drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH v5 12/12] block: Only clone bio vecs that
 are in use
Message-ID: <20120808232804.GL6983@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-13-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208061913500.21956@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1208061913500.21956@file.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 07:16:33PM -0400, Mikulas Patocka wrote:
> Hi Kent
> 
> When you change the semantics of an exported function, rename that 
> function. There may be external modules that use __bio_clone and this 
> change could silently introduce bugs in them.
> 
> Otherwise, the patchset looks fine.

I don't know.  This doesn't change the main functionality and should
be transparent unless the caller is doing something crazy.  It *might*
be nice to rename but I don't think that's a must here.

Thanks.

-- 
tejun
