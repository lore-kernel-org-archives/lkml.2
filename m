Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab1HFAjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:39:03 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:40149 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751501Ab1HFAi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:38:59 -0400
Date: Fri, 5 Aug 2011 17:38:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jinyoung Park <jinyoungp@nvidia.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: aat2870 causes build failure in current upstream
Message-Id: <20110805173857.b1a23e59.rdunlap@xenotime.net>
In-Reply-To: <4E3C18D7.9070303@zytor.com>
References: <4E385B53.3040108@zytor.com>
	<20110804171725.GA12729@elte.hu>
	<4E3B87C2.3020304@nvidia.com>
	<4E3C18D7.9070303@zytor.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Aug 2011 09:22:47 -0700 H. Peter Anvin wrote:

> On 08/04/2011 11:03 PM, Jinyoung Park wrote:
> > Hi,
> > 
> > I try to check allmodconfig error issue for aat2870 backlight driver.
> > But I could not observing error message what you attached, building is
> > successed.
> > Please let me know how to reproduce allmodconfig problem for aat2870
> > backlight driver.
> > 
> > This is my repro step.
> > $ git clone
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > $ cd linux-next
> > $ make allmodconfig
> > $ make
> > 
> > Thanks,
> > Jin.
> > 
> 
> Get Linus' current tree, not linux-next.

Now fixed?  current mainline i386 allmodconfig builds OK for me.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
