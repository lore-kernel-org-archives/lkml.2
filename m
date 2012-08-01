Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab2HAWqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 18:46:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64865 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab2HAWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 18:46:00 -0400
Date: Wed, 1 Aug 2012 15:45:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
Message-ID: <20120801224556.GF15477@google.com>
References: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com>
 <1343757920-19713-2-git-send-email-levinsasha928@gmail.com>
 <20120731182330.GD21292@google.com>
 <50197348.9010101@gmail.com>
 <20120801182112.GC15477@google.com>
 <50197460.8010906@gmail.com>
 <20120801182749.GD15477@google.com>
 <50197E4A.7020408@gmail.com>
 <20120801202432.GE15477@google.com>
 <5019B0B4.1090102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5019B0B4.1090102@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 12:41:56AM +0200, Sasha Levin wrote:
> How would your DEFINE_HASHTABLE look like if we got for the simple
> 'struct hash_table' approach?

I think defining a different enclosing anonymous struct which the
requested number of array entries and then aliasing the actual
hash_table to that symbol should work.  It's rather horrible and I'm
not sure it's worth the trouble.

Thanks.

-- 
tejun
