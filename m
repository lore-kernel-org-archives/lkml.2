Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab0LUMvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 07:51:23 -0500
Received: from adelie.canonical.com ([91.189.90.139]:45898 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0LUMvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 07:51:22 -0500
Date: Tue, 21 Dec 2010 12:51:10 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] scripts: add no-warning option to the
 checkpatch script
Message-ID: <20101221125110.GI18715@shadowen.org>
References: <4D0DD027.4000507@gmail.com>
 <1292813544.22702.342.camel@Joe-Laptop>
 <AANLkTi=WP9k_yqyvvJmy2ZW0ErO9Yt=jQjVvWQ_RGByv@mail.gmail.com>
 <1292836937.22702.424.camel@Joe-Laptop>
 <AANLkTimNe7_3Za6YgY69zEuXYCmU4dZdCjfLN2QMM=jb@mail.gmail.com>
 <1292846770.22702.440.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292846770.22702.440.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:06:10AM -0800, Joe Perches wrote:
> On Mon, 2010-12-20 at 12:48 +0100, Marco Stornelli wrote:
> > 2010/12/20 Joe Perches <joe@perches.com>:
> > > On Mon, 2010-12-20 at 09:37 +0100, Marco Stornelli wrote:
> > >> 2010/12/20 Joe Perches <joe@perches.com>:
> > >> > Why do you think it's useful?
> > >> To "debug" a patch from style point of view, I think it's useful to
> > >> fix before the errors and then the warnings. So this option it's
> > >> useful as a "filter". However, I added you in cc: because of a reply
> > >> to my first patch that indicated you as a person interested in this
> > >> scope.
> > > Perhaps then it'd be better to filter/enable/disable
> > > the 3 current categories of messages.
> > > Maybe something like this:
> > Yeah, very good. Will it be inserted in mainline?
> 
> Dunno.  Maybe if Andy thinks it worthwhile.
> He takes his time about this sort of thing.

At a quick skim that seems a more comprehensive approach.  I've been lax
as always picking things up but with the quiet time coming I hope to
hoover up the left overs and push them out.

Thanks.

-apw
