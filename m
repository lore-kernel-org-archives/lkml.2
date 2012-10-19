Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab2JSAnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:43:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33216 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751913Ab2JSAnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:43:18 -0400
Message-ID: <1350607397.22385.11.camel@joe-AO722>
Subject: Re: [PATCH 00/23] printk: refactoring
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Date: Thu, 18 Oct 2012 17:43:17 -0700
In-Reply-To: <20121018161601.c47c50c8.akpm@linux-foundation.org>
References: <cover.1350449851.git.joe@perches.com>
	 <20121018161601.c47c50c8.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:16 -0700, Andrew Morton wrote:
> On Tue, 16 Oct 2012 23:06:04 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > Make printk a bit more readable.
[]
> OK, nobody's allowed to change the printk code for two months.

[filelist]

> It wouldn't hurt to describe the design here a bit.  How was the code
> partitioned and what is the role of each file?

Design?  Have you looked at printk recently?

I think you called it something like "eye gouging"
or maybe "burn it down".

Dunno how anyone could consider what there anything
other than accreted.

I just tried to break it up into somewhat sensible blocks.

> That's reasonably obvious from the names, but some might wonder about
> the difference between printk_log and printk_syslog and how that
> division was decided upon.

None of the filenames are great.

I still want to break out the console code from what's
left of printk.c eventually.

I think what would help most is a Documentation/printk.txt
file explaining how it all works.

cheers, Joe

