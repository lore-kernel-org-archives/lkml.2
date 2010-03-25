Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0CYOpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:45:30 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42935 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab0CYOp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:45:29 -0400
Date: Thu, 25 Mar 2010 15:45:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: linux-kernel@vger.kernel.org, nauman@google.com, vgoyal@redhat.com
Subject: Re: [PATCH] cfq-iosched: Do not merge queues of BE and IDLE classes
Message-ID: <20100325144528.GW5768@kernel.dk>
References: <20100324205127.7477.97997.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324205127.7477.97997.stgit@austin.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24 2010, Divyesh Shah wrote:
> even if they are found to be co-operating.
> 
> The prio_trees do not have any IDLE cfqqs on them. cfq_close_cooperator()
> is called from cfq_select_queue() and cfq_completed_request(). The latter
> ensures that the close cooperator code does not get invoked if the current
> cfqq is of class IDLE but the former doesn't seem to have any such checks.
> So an IDLE cfqq may get merged with a BE cfqq from the same group which
> should be avoided.

Thanks, applied.

-- 
Jens Axboe

