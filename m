Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab2JERV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:21:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63423 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619Ab2JERV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:21:27 -0400
MIME-Version: 1.0
In-Reply-To: <1349457161.6755.61.camel@gandalf.local.home>
References: <1349253783-21612-7-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349254399-22742-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349455743.6755.57.camel@gandalf.local.home>
	<CAHp75Vc1a-4LtuTun=urBLvroLqsok4zeW-Fqm-uDK9izmsR6w@mail.gmail.com>
	<1349457161.6755.61.camel@gandalf.local.home>
Date: Fri, 5 Oct 2012 20:21:26 +0300
Message-ID: <CAHp75Vcvw-uc+2srSSTrdcUqU_rTsMS5k7cLrvkRtiLve6aNvw@mail.gmail.com>
Subject: Re: [PATCHv2.5] trace: reuse kbasename() functionality
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 8:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-10-05 at 20:02 +0300, Andy Shevchenko wrote:
>
>> > I don't see kbasename() anywhere. Is this based off of other patches?
>> It's introduced by first patch in the series.
> Usually a series has the format of:
>
> [PATCH x/n] ....
>
> Where x is the patch number and n is the total number of patches. I'm
> not sure what a v2.5 is. This is version 2 and a half?
Ah, it's an update to patch 6/6. You could see it by
Message-Id/In-Reply-To chains.

-- 
With Best Regards,
Andy Shevchenko
