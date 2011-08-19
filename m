Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1HSBKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 21:10:25 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57639 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1HSBKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 21:10:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110818145213.db5a9d65.akpm@linux-foundation.org>
References: <201106082045.p58Kjwmd027729@imap1.linux-foundation.org>
	<BANLkTikAvnam2WNTBMj_J5yBHrxJxSjLuw@mail.gmail.com>
	<BANLkTimPT-LEsEs34dvPZNbVKnwCT8ck6g@mail.gmail.com>
	<20110818145213.db5a9d65.akpm@linux-foundation.org>
Date: Fri, 19 Aug 2011 09:10:23 +0800
Message-ID: <CABqxG0cXmW0FKjHo9bZZo2PE7cVWtcZtPpeePH_Tsn+kdT7q=Q@mail.gmail.com>
Subject: Re: + sysctl-add-proc_dointvec_unsigned-handler-update.patch added to
 -mm tree
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 5:52 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 10 Jun 2011 17:51:50 +0800
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> On Fri, Jun 10, 2011 at 1:19 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> > On Wed, Jun 8, 2011 at 11:45 PM,  <akpm@linux-foundation.org> wrote:
>> >> --- a/kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler-update
>> >> +++ a/kernel/sysctl.c
>> >> @@ -2515,6 +2515,7 @@ int proc_dointvec_unsigned(struct ctl_ta
>> >>  {
>> >>        struct do_proc_dointvec_minmax_conv_param param = {
>> >>                .min = &zero,
>> >> +               .max = (int *) table->extra2,
>> >>        };
>> >>        return do_proc_dointvec(table, write, buffer, lenp, ppos,
>> >>                                do_proc_dointvec_minmax_conv, &param);
>> >
>> > This is still buggybecause "zero" is only 1 variable and max can be an array.
>> > Sysctl boundary comparisons are done element-by-element.
>>
>> Where's the array use case?
>
> Guys, these patches:
>
> sysctl-add-proc_dointvec_bool-handler.patch
> sysctl-use-proc_dointvec_bool-where-appropriate.patch
> sysctl-add-proc_dointvec_unsigned-handler.patch
> sysctl-add-proc_dointvec_unsigned-handler-update.patch
> sysctl-use-proc_dointvec_unsigned-where-appropriate.patch
>
> are still floating about in my tree, and stuck.
>
> As everyone has forgotten all about it I think I'll just drop the
> patches.  If you're still motivated, please resend from scratch and
> let's take another look at them.  And this time please let's drive the
> discussion to a conclusion and not leave stuff floating around
> unresolved for months?
>

Sorry about that situation, Consider the alexey's concern maybe I will
 resend only the "bool" patches.

-- 
Regards
Yang RuiRui
