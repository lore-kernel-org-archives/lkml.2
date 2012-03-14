Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965000Ab2CNBRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:17:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36650 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932284Ab2CNBRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:17:12 -0400
Message-ID: <1331687831.27389.2.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Mar 2012 18:17:11 -0700
In-Reply-To: <20120314010701.GB15379@thunk.org>
References: <1330661602.1939.13.camel@joe2Laptop>
	 <1330666534.1939.19.camel@joe2Laptop> <1330667673.1939.22.camel@joe2Laptop>
	 <1331619783.7100.8.camel@joe2Laptop> <20120313120514.GA17538@thunk.org>
	 <20120313145517.f4fcae46.akpm@linux-foundation.org>
	 <20120313220144.GD11969@thunk.org>
	 <20120313150316.6ae19b95.akpm@linux-foundation.org>
	 <20120314003157.GA15379@thunk.org> <1331686026.24613.6.camel@joe2Laptop>
	 <20120314010701.GB15379@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 21:07 -0400, Ted Ts'o wrote:
> On Tue, Mar 13, 2012 at 05:47:06PM -0700, Joe Perches wrote:
> > Or add an I: line to MAINTAINERS
> > 
> > though perhaps it's better to agree on a style.
> > 
> > I did send a few fixes and a style consolidation patch
> > for ext4 with no reply awhile ago:
> > 
> > https://lkml.org/lkml/2011/8/2/41
> 
> You combined a huge number of changes into a single patch, and as far
> as I was concerned the value it added Just Wasn't Worth It.  It adds
> noise which causes other patches, which add real value, not to apply
> cleanly.
> 
> I routinely ignore such patches because I have a limited amount of
> time, and as far as I'm concerned they mainly make my life harder.
> 
> Looking more closely, there are a few changes in there that I'd
> accept, but it was burried amongst so much other junk that if it's all
> or nothing, it would be nothing.  Funny that someone who is an expert
> in style things neglected something **far** more important ---
> segregate logical changes in separate commits; don't collapse
> everything into a single patch, which makes it hard to review.

The patch was all apiece, every bit associated to logging output.
It was bundled to make it easier to apply.

You call it junk, I call it cleanups.

Consistent style in a largish project has advantages.
You can ignore them if you choose.

