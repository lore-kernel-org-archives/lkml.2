Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428Ab2EWCCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:02:06 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50923 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753038Ab2EWCCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:02:04 -0400
Message-ID: <1337738520.13111.17.camel@joe2Laptop>
Subject: Re: [PATCH 1/1] checkpatch: don't fake typedefs with #define
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, linux-kernel@vger.kernel.org,
        apw@canonical.com
Date: Tue, 22 May 2012 19:02:00 -0700
In-Reply-To: <4FBC4372.5070000@gmail.com>
References: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <1337288048.17726.64.camel@joe2Laptop>
	 <20120517211641.GC27953@pcarmody2.research.nokia.com>
	 <4FBC4372.5070000@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 11:54 +1000, Ryan Mallon wrote:
> On 18/05/12 07:16, Phil Carmody wrote:
> > Too many. Alas I can't share them. 
> That sounds like the cases you have seen are in code which is not
> public. I don't think I have ever seen code in the kernel, or in
> proposed patches which fakes a typedef with a #define.
> 
> Is this an issue for public code, or for a private company tree? In the
> latter case, the checkpatch addition should go in your private tree,
> rather than mainline. It looks like, at least for mainline Linux, you
> are trying to solve a non-existent problem.

I agree it's pretty rare.

$ git grep -E "#\s*define\s+\w+\s+(struct|union)\b"|wc -l
57

Perhaps rarity shouldn't be enough to exclude the test though.

If Andy or Andrew wants to take it though, it's not a big
maintenance burden.

