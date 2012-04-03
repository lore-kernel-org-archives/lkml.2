Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2DCQMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:12:08 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:59978 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2DCQMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:12:06 -0400
MIME-Version: 1.0
In-Reply-To: <1333469136.26079.33.camel@joe2Laptop>
References: <1333415903.860.0.camel@mop> <1333420612.26079.6.camel@joe2Laptop>
 <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
 <1333424865.26079.9.camel@joe2Laptop> <CAPXgP13fDRZtAvV651NPqQ2TgUEtb+MX1EhKhwirAgoiNOg5tQ@mail.gmail.com>
 <1333463572.26079.31.camel@joe2Laptop> <CAPXgP133MQX2u3H6imOR4FFR4TsHYc=f_yrAJfdd2sG-8bFrmA@mail.gmail.com>
 <1333469136.26079.33.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 3 Apr 2012 18:11:44 +0200
Message-ID: <CAPXgP11MBdqc3BiDLA1q5gW4BZy2q4PoLtD20oRXfKY+C-HOgw@mail.gmail.com>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 18:05, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-04-03 at 17:50 +0200, Kay Sievers wrote:
>> I did not claim to address the problem of concurrent continuation line
>> writers, and this patch has absolutely nothing to do with that
>> problem. It _does_ fix encountered problems,
>
> No it doesn't.  It fixes problems _you_ encounter
> with an unpublished modification of the printk
> subsystem.

Exactly. And that is what is written in the changelog of the patch.
But all that does not matter, the change results in more correct code
than the current one is; and that is all that matters.

Sure, I see your point, and support your effort, but I don't think
your arguments are related to this patch and you are hijacking
something unrelated, which should be discussed in a separate mail
thread, that's all.

Thanks,
Kay
