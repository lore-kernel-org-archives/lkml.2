Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab2CNOGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:06:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38871 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753797Ab2CNOGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:06:17 -0400
Message-ID: <1331733975.27389.80.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 14 Mar 2012 07:06:15 -0700
In-Reply-To: <20120314134520.GA26524@thunk.org>
References: <20120314003157.GA15379@thunk.org>
	 <1331686026.24613.6.camel@joe2Laptop> <20120314010701.GB15379@thunk.org>
	 <1331687831.27389.2.camel@joe2Laptop> <20120314021938.GD15379@thunk.org>
	 <1331692311.27389.27.camel@joe2Laptop> <20120314024104.GE15379@thunk.org>
	 <1331694074.27389.42.camel@joe2Laptop> <20120314123429.GG15379@thunk.org>
	 <1331730336.27389.70.camel@joe2Laptop> <20120314134520.GA26524@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 08:34 -0400, Ted Ts'o wrote:
> Look, the reason why I care about patch noise is because I have a huge
> patch backlog.  Take a look at this:
>       http://patchwork.ozlabs.org/project/linux-ext4/list/

On Wed, 2012-03-14 at 09:45 -0400, Ted Ts'o wrote:
> On Wed, Mar 14, 2012 at 06:05:36AM -0700, Joe Perches wrote:
> > If you actually use patchwork, though it seems you don't,
> > I think you should just mark every patch that's new as
> > rejected and start over.
> I use it, but not in the way you think I should be using it.

Given the information in the link you sent,
it's not possible for anyone but you to
assess your patch backlog.

cheers, Joe

