Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1HRVwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:52:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324Ab1HRVwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:52:14 -0400
Date: Thu, 18 Aug 2011 14:52:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com
Subject: Re: + sysctl-add-proc_dointvec_unsigned-handler-update.patch added
 to -mm tree
Message-Id: <20110818145213.db5a9d65.akpm@linux-foundation.org>
In-Reply-To: <BANLkTimPT-LEsEs34dvPZNbVKnwCT8ck6g@mail.gmail.com>
References: <201106082045.p58Kjwmd027729@imap1.linux-foundation.org>
	<BANLkTikAvnam2WNTBMj_J5yBHrxJxSjLuw@mail.gmail.com>
	<BANLkTimPT-LEsEs34dvPZNbVKnwCT8ck6g@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 17:51:50 +0800
Dave Young <hidave.darkstar@gmail.com> wrote:

> On Fri, Jun 10, 2011 at 1:19 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > On Wed, Jun 8, 2011 at 11:45 PM,  <akpm@linux-foundation.org> wrote:
> >> --- a/kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler-update
> >> +++ a/kernel/sysctl.c
> >> @@ -2515,6 +2515,7 @@ int proc_dointvec_unsigned(struct ctl_ta
> >>  {
> >>        struct do_proc_dointvec_minmax_conv_param param = {
> >>                .min = &zero,
> >> +               .max = (int *) table->extra2,
> >>        };
> >>        return do_proc_dointvec(table, write, buffer, lenp, ppos,
> >>                                do_proc_dointvec_minmax_conv, &param);
> >
> > This is still buggybecause "zero" is only 1 variable and max can be an array.
> > Sysctl boundary comparisons are done element-by-element.
> 
> Where's the array use case?

Guys, these patches:

sysctl-add-proc_dointvec_bool-handler.patch
sysctl-use-proc_dointvec_bool-where-appropriate.patch
sysctl-add-proc_dointvec_unsigned-handler.patch
sysctl-add-proc_dointvec_unsigned-handler-update.patch
sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

are still floating about in my tree, and stuck.

As everyone has forgotten all about it I think I'll just drop the
patches.  If you're still motivated, please resend from scratch and
let's take another look at them.  And this time please let's drive the
discussion to a conclusion and not leave stuff floating around
unresolved for months?

