Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965486Ab2ERRIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:08:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61859 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab2ERRIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:08:41 -0400
Date: Fri, 18 May 2012 10:08:36 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 11/13] Closures
Message-ID: <20120518170836.GK19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <a184989cfbf92297d4cca2f823e5ac24ec8fe1e3.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a184989cfbf92297d4cca2f823e5ac24ec8fe1e3.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:59:58PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> Asynchronous refcounty thingies; they embed a refcount and a work
> struct. Extensive documentation follows in include/linux/closure.h
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

I don't think this fits in this series and the more I think about it
the more I don't like this but let's have that discussion in different
threads, so tentaive NACK.

Thanks.

-- 
tejun
