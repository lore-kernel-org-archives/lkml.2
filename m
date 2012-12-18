Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2LRTSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:18:07 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:44109 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2LRTSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:18:03 -0500
Date: Tue, 18 Dec 2012 11:17:56 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 09/12] cfq-iosched: enable full blkcg hierarchy support
Message-ID: <20121218191756.GP1844@htj.dyndns.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-10-git-send-email-tj@kernel.org>
 <20121218184022.GC24050@redhat.com>
 <20121218191055.GN1844@htj.dyndns.org>
 <20121218191645.GA25908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218191645.GA25908@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Dec 18, 2012 at 02:16:45PM -0500, Vivek Goyal wrote:
> > Yeah, sure thing.  Other than documentation / field names, do things
> > look okay to you?  If so, I'll post updated round once -rc1 happens.
> 
> Yes, in general things look good to me with this patch.

Cool.

> /me is wondering how to get a response from cpu controller folks.

Well, I pinged Peter last time about it and didn't get any response.
Prolly best to ping w/ patch.

Thanks.

-- 
tejun
