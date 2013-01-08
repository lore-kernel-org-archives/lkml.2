Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3AHRTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:19:36 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55470 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3AHRTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:19:34 -0500
Date: Tue, 8 Jan 2013 09:19:29 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH UPDATED 15/24] cfq-iosched: enable full blkcg hierarchy
 support
Message-ID: <20130108171929.GX3926@htj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-16-git-send-email-tj@kernel.org>
 <20130107163405.GE3926@htj.dyndns.org>
 <20130108144240.GA29635@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108144240.GA29635@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Tue, Jan 08, 2013 at 09:42:40AM -0500, Vivek Goyal wrote:
> > +A has children and further distributes its 57% among the children and
> > +the implicit leaf node. The total active weight at this level is
> > +AA:500 + AB:1000 + A-leaf:750 = 2250.
> > +
> > + A-leaf    : ( 750 / 2250) * A =~ 19%
> > + AA(-leaf) : ( 500 / 2250) * A =~ 12%
> > + AB(-leaf) : (1000 / 2250) * A =~ 25%
> 
> Hi Tejun,
> 
> What does (-leaf) is supposed to signify? I can understand that A-leaf
> tells the share of A's tasks which are effectively in A-leaf group. 

It's saying that the weight for AA and AA-leaf are the same.

> Will just plain AA and AB be more clear?

I don't know, maybe.

Thanks.

-- 
tejun
