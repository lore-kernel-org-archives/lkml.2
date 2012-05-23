Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860Ab2EWPPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:15:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759845Ab2EWPPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:15:45 -0400
Date: Wed, 23 May 2012 11:15:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tejun@google.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        agk@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [Bcache v13 09/16] Bcache: generic utility code
Message-ID: <20120523151538.GJ14943@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
 <20120522211706.GH14339@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522211706.GH14339@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 02:17:06PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> I've been reading the code and am still very far from understanding
> the whole thing but here are general impressions upto this point.
> 
> * I started reading from get_bucket(), mostly because I wasn't sure
>   where to start.  It would be very helpful to the reviewers and
>   future participants if there's a design doc and more comments (much
>   more).  The code is on the big side and the problem is exacerbated
>   by use of somewhat unconventional constructs and conventions and
>   lack of documentation and comments.

I totally agreed. There is a lot going on and design doc is going to 
help a lot while reviewing.

> * Too many smart macros.  Macros suck.  Smart ones double suck.

I had the same impression when I tried to read the code last. Too many
macros and it makes reading code really difficult.

[..]
> * Somewhat related to the above, I'm not a fan of super-verbose
>   symbols but I *hope* that the variable names were just a tiny bit
>   more descriptive.  At least, the ones used as arguments.

Another thing is that keep variable names consistent. Last time I looked,
same name "c" was being used to represent cached_dev or cache_set or 
something else too. If we keep variable name same to represent same
data structure, it becomes easier to read the code. I was totally lost
and always had to go back to figure out what "c" is representing, what
"d" is representing etc.

Thanks
Vivek
