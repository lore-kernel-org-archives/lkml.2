Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab2HAS1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 14:27:55 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52801 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2HAS1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 14:27:54 -0400
Date: Wed, 1 Aug 2012 11:27:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
Message-ID: <20120801182749.GD15477@google.com>
References: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com>
 <1343757920-19713-2-git-send-email-levinsasha928@gmail.com>
 <20120731182330.GD21292@google.com>
 <50197348.9010101@gmail.com>
 <20120801182112.GC15477@google.com>
 <50197460.8010906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50197460.8010906@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 08:24:32PM +0200, Sasha Levin wrote:
> On 08/01/2012 08:21 PM, Tejun Heo wrote:
> > On Wed, Aug 01, 2012 at 08:19:52PM +0200, Sasha Levin wrote:
> >> If we switch to using functions, we could no longer hide it anywhere
> >> (we'd need to either turn the buckets into a struct, or have the
> >> user pass it around to all functions).
> > 
> > Create an outer struct hash_table which remembers the size?
> 
> Possible. I just wanted to avoid creating new structs where they're not really required.
> 
> Do you think it's worth it for eliminating those two macros?

What if someone wants to allocate hashtable dynamically which isn't
too unlikely?  I think it's best to stay away from macro tricks as
much as possible although I gotta admit I fall into the macro trap
more often than I would like.

Thanks.

-- 
tejun
