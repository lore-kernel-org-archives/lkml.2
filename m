Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab2BWSU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:20:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440Ab2BWSU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:20:57 -0500
Date: Thu, 23 Feb 2012 13:20:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 33/36] block: add io_context->active_ref
Message-ID: <20120223182046.GF19691@redhat.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <1329875223-5102-34-git-send-email-tj@kernel.org>
 <20120222184736.GE4128@redhat.com>
 <20120222191347.GB17480@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222191347.GB17480@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 11:13:47AM -0800, Tejun Heo wrote:

[..]
> It indeed is ugly to have ref, active_ref and nr_tasks tho.  If we can
> remove CLONE_IO, nr_tasks will go away with it.  Maybe, I don't know.
> Let's see.

I just remembered following commit where a race was fixed and in this
case two processes were sharing io context.

>From 5eb46851de3904cd1be9192fdacb8d34deadc1fc Mon Sep 17 00:00:00 2001
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Date: Fri, 2 Dec 2011 10:07:07 +0100
Subject: [PATCH 1/1] cfq-iosched: fix cfq_cic_link() race confition

Just thought of mentioning here. It shows somebody out there uses 
and cares about CLONE_IO.

Thanks
Vivek
