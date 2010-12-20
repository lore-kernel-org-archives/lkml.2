Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0LTMGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:06:13 -0500
Received: from mail.perches.com ([173.55.12.10]:2783 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288Ab0LTMGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:06:12 -0500
Subject: Re: [PATCH][RESEND] scripts: add no-warning option to the
 checkpatch script
From: Joe Perches <joe@perches.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, apw@canonical.com
In-Reply-To: <AANLkTimNe7_3Za6YgY69zEuXYCmU4dZdCjfLN2QMM=jb@mail.gmail.com>
References: <4D0DD027.4000507@gmail.com>
	 <1292813544.22702.342.camel@Joe-Laptop>
	 <AANLkTi=WP9k_yqyvvJmy2ZW0ErO9Yt=jQjVvWQ_RGByv@mail.gmail.com>
	 <1292836937.22702.424.camel@Joe-Laptop>
	 <AANLkTimNe7_3Za6YgY69zEuXYCmU4dZdCjfLN2QMM=jb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 04:06:10 -0800
Message-ID: <1292846770.22702.440.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 12:48 +0100, Marco Stornelli wrote:
> 2010/12/20 Joe Perches <joe@perches.com>:
> > On Mon, 2010-12-20 at 09:37 +0100, Marco Stornelli wrote:
> >> 2010/12/20 Joe Perches <joe@perches.com>:
> >> > Why do you think it's useful?
> >> To "debug" a patch from style point of view, I think it's useful to
> >> fix before the errors and then the warnings. So this option it's
> >> useful as a "filter". However, I added you in cc: because of a reply
> >> to my first patch that indicated you as a person interested in this
> >> scope.
> > Perhaps then it'd be better to filter/enable/disable
> > the 3 current categories of messages.
> > Maybe something like this:
> Yeah, very good. Will it be inserted in mainline?

Dunno.  Maybe if Andy thinks it worthwhile.
He takes his time about this sort of thing.

