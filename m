Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab0DWTlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:41:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49894 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab0DWTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:41:25 -0400
Date: Fri, 23 Apr 2010 12:41:22 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] block: Add a trace point whenever a barrier IO request
	is sent
Message-ID: <20100423194122.GB15607@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20100421205626.GA15607@tux1.beaverton.ibm.com> <20100421212727.GY27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421212727.GY27497@kernel.dk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 11:27:27PM +0200, Jens Axboe wrote:
> On Wed, Apr 21 2010, Darrick J. Wong wrote:
> > Simple debugging patch used to watch for barrier requests.  I've been using
> > this to watch ext4's barrier=1 behavior.
> 
> But barriers are already being logged, if you watch blkparse data, it'll
> be RB or WB events. So I don't see what this addition provides that we
> don't already have?

I also have the function graph tracer turned on, so I can (try to) map barrier
requests to specific chunks of ext4 code.  But, maybe there's a way to do this
with blkparse that I haven't found yet?

--D
