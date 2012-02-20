Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2BTOgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:36:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab2BTOgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:36:31 -0500
Date: Mon, 20 Feb 2012 09:36:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120220143622.GB10342@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
 <20120217225125.GK26620@redhat.com>
 <20120217225735.GP29414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217225735.GP29414@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 02:57:35PM -0800, Tejun Heo wrote:

[..]
> blkcg doesn't allow that anyway (it tries but is racy) and I actually
> was thinking about sending a RFC patch to kill CLONE_IO.

Hi  Tejun,

I have a question about CLONE_IO.

In copy_io(), we don't share the io_context if "current" does not have
task->io_context set. Does that mean if even if I specify CLONE_IO, two
threads might not share io context depending on when clone() happened? Or
I am reading the code wrong.

Thanks
Vivek
