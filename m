Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2EASgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:36:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab2EASgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:36:14 -0400
Date: Tue, 1 May 2012 14:36:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Moyer Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be
 initialized to one
Message-ID: <20120501183610.GD18239@redhat.com>
References: <1335873936.16988.148.camel@lappy>
 <20120501161729.GV26595@google.com>
 <4FA0253F.4000302@fusionio.com>
 <20120501180906.GX26595@google.com>
 <4FA028EE.7020208@fusionio.com>
 <x49wr4vlpn8.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49wr4vlpn8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 02:31:07PM -0400, Jeff Moyer wrote:

[..]
> > But as to actual users, I really don't know. I agree it's probably not
> > that widely used. If google still had that code search, we could get a
> > better idea :-)
> 
> I know of one project: the venerable dump/restore utility uses CLONE_IO.

I thought you wrote cooperating queue logic to fix dump as it was not
using CLONE_IO and IO from multiple threads was going in separate 
queues.

Thanks
Vivek
