Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2BVU36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:29:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56765 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2BVU34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:29:56 -0500
Date: Thu, 23 Feb 2012 00:29:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Feb 17 (kernel/kcmp.c)
Message-ID: <20120222202952.GA16093@moon>
References: <20120217165045.2394d944d6efc37104421d2e@canb.auug.org.au>
 <4F3E95B7.3010700@xenotime.net>
 <20120218101446.64a7ea590b66f337762bfb57@canb.auug.org.au>
 <20120218065846.GA1905@moon>
 <4F454E20.2060505@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F454E20.2060505@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 12:20:48PM -0800, Randy Dunlap wrote:
...
> 
> Since this build error is still occurring in linux-next 20120222,
> I looked and found that the Ecode is misspelled.
> 
> Please s/EOPNOTSUP/EOPNOTSUPP/
> 

Thanks!

	Cyrill
