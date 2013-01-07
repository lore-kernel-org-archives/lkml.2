Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3AGQen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:34:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38468 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3AGQel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:34:41 -0500
Date: Mon, 7 Jan 2013 08:34:37 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] block: implement blkcg hierarchy support in cfq,
 take#2
Message-ID: <20130107163437.GF3926@htj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <20130102182037.GC4306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102182037.GC4306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 01:20:38PM -0500, Vivek Goyal wrote:
> On Fri, Dec 28, 2012 at 12:35:22PM -0800, Tejun Heo wrote:
> 
> [..]
> > 
> > * Updated to reflect Vivek's reviews - renames & documentation.
> 
> Hi Tejun,
> 
> You forgot to update blkio-controller.txt.

Just updated.  Does everything else look okay to you?

Thanks.

-- 
tejun
