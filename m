Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327Ab2D0OyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:54:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760313Ab2D0OyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:54:10 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
	<1335477561-11131-12-git-send-email-tj@kernel.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 27 Apr 2012 10:54:01 -0400
In-Reply-To: <1335477561-11131-12-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Thu, 26 Apr 2012 14:59:21 -0700")
Message-ID: <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> This patch implements per-blkg request_list.  Each blkg has its own
> request_list and any IO allocates its request from the matching blkg
> making blkcgs completely isolated in terms of request allocation.

So, nr_requests is now actually nr_requests * # of blk cgroups.  Is that
right?  Are you at all concerned about the amount of memory that can be
tied up as the number of cgroups increases?

Cheers,
Jeff
