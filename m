Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab0DZRrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:47:25 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33444 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab0DZRrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:47:24 -0400
Date: Mon, 26 Apr 2010 19:47:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com
Subject: Re: [PATCH 0/4] blkdev: blkdev_issue_fn cleanups v2
Message-ID: <20100426174722.GV27497@kernel.dk>
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org> <20100426150144.GB2937@infradead.org> <20100426172651.GT27497@kernel.dk> <87k4ruce6u.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k4ruce6u.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26 2010, Dmitry Monakhov wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Mon, Apr 26 2010, Christoph Hellwig wrote:
> >> Jens, are you planning on picking up a version of this?
> >
> > Yes, I was waiting for a repost to address your review concerns.
> Ok, will appear in several hours. I have to repeat full testing
> cycle, I don't want to break lvm one more time :)

Take your time, I would appreciate it if lvm didn't get broken again :-)

-- 
Jens Axboe

