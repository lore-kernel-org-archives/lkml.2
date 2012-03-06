Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2CFQZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:25:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645Ab2CFQZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:25:00 -0500
Date: Tue, 6 Mar 2012 11:24:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] blkcg: accumulated blkcg updates
Message-ID: <20120306162455.GB32148@redhat.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <20120305210726.GC1263@google.com>
 <20120305210836.GD1263@google.com>
 <20120306150709.GA32148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306150709.GA32148@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 10:07:09AM -0500, Vivek Goyal wrote:

[..]
> 
> My system is hanging during reboot. Last message I see is "Detaching DM
> devices" and nothing happens after that. I shall have to do some more 
> testing to figure out when did that start happening.

Ok, git bisect shows that very first patch to drain the queue is culprit.

9e5b9f8 block: blk-throttle should be drained regardless of q->elevator

Will do some more debugging.

Thanks
Vivek

