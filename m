Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0CYOoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:44:21 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57835 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab0CYOoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:44:20 -0400
Date: Thu, 25 Mar 2010 15:44:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: linux-kernel@vger.kernel.org, nauman@google.com, vgoyal@redhat.com,
       ctalbott@google.com
Subject: Re: [PATCH][v2] cfq-iosched: Add additional blktrace log messages
	in CFQ  for easier debugging.
Message-ID: <20100325144418.GV5768@kernel.dk>
References: <20100325013655.6103.13377.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325013655.6103.13377.stgit@austin.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24 2010, Divyesh Shah wrote:
> These have helped us debug some issues we've noticed in earlier IO
> controller versions and should be useful now as well. The extra logging
> covers:
> - idling behavior. Since there are so many conditions based on which we decide
> to idle or not, this patch adds a log message for some conditions that we've
> found useful.
> - workload slices and current prio and workload type
> 
> Changelog from v1:
> o moved log message from cfq_set_active_queue() to __cfq_set_active_queue()
> o changed queue_count to st->count

Definitely makes sense, thanks I'll queue it up.

-- 
Jens Axboe

