Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0IHTu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:50:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497Ab0IHTuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:50:55 -0400
Date: Wed, 8 Sep 2010 12:50:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hunter Adrian <adrian.hunter@nokia.com>, Chris Ball <cjb@laptop.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCHv6 3/3] mmc_test: collect data and show it via sysfs by
 demand
Message-Id: <20100908125017.686ebebd.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikV4TvwtwQHnb_p9HBsJTV4hVmbpvjKs6MvbYo=@mail.gmail.com>
References: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<ba5173c9b420d9554c83965f47d0b5cba642743a.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<d7cf4d98c6e0396da903c2e49b028f240853bfc2.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<20100907152753.4726c076.akpm@linux-foundation.org>
	<AANLkTikV4TvwtwQHnb_p9HBsJTV4hVmbpvjKs6MvbYo=@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010 12:08:58 +0300
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Wed, Sep 8, 2010 at 1:27 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> Here is a patch which brings possibility to get test results via sysfs. It
> >> helps to do tests non-interactively.
> >>
> >> We have the file created under sysfs already and we could use it to out test
> >> results.
> >
> > So what we end up with is extremely thin. __Something about adding
> > something to sysfs.
> Yeah, agree with you. How to proceed with commit messages?
> Should I make newer version of this certain patch with updated commit message?
> 

I used the words which Chris sent:


: Make it possibile to get test results via sysfs.  It helps to do tests
: non-interactively.
: 
: We have the file created under sysfs already and we could use it to out test
: results.
: 
: Prior to this patch, the "test" file under each card's sysfs node was
: write-only, and results were obtained by looking at dmesg.  This patch
: improves programmatic access to the test results, making them available by
: reading back from the same "test" file:
: 
: [root@host mmc0:e624]# echo 6 > test
: [root@host mmc0:e624]# cat test
: Test 6: 2
: 
: [cjb@laptop.org: changelog improvements]
: Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
: Cc: Chris Ball <cjb@laptop.org>
: Cc: <linux-mmc@vger.kernel.org>

which is good enough.  You can send me replacement changelog text any
old time - it's not problem.  I'm forever editing changelogs, mainly
adding acked-by's etc.  

