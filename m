Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2JMOx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 10:53:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43433 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2JMOxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 10:53:53 -0400
MIME-Version: 1.0
In-Reply-To: <1350136476.24256.96.camel@gandalf.local.home>
References: <20121013022632.024527228@goodmis.org>
	<20121013022953.015897288@goodmis.org>
	<201210130012.40451.vapier@gentoo.org>
	<1350136476.24256.96.camel@gandalf.local.home>
Date: Sat, 13 Oct 2012 22:53:52 +0800
Message-ID: <CAA_GA1dFubSrquBsFGF-GYWf04Rn6bivZui0SiXCVhN0zTaFnw@mail.gmail.com>
Subject: Re: [PATCH 04/25] blackfin: Use Kbuild infrastructure for kvm_para.h
From: Bob Liu <lliubbo@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Sat, Oct 13, 2012 at 9:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2012-10-13 at 00:12 -0400, Mike Frysinger wrote:
>> On Friday 12 October 2012 22:26:36 Steven Rostedt wrote:
>> > From: Steven Rostedt <srostedt@redhat.com>
>> >
>> > All the headers but kvm_para.h use the Kbuild infrastructure to
>> > get to the asm-generic headers.
>>
>> Acked-by: Mike Frysinger <vapier@gentoo.org>
>> -mike
>
> Thanks Mike,
>
> Would you want to pull this patch into your tree? It's not dependent on
> any of the other patches.
>

I'll apply this patch to blackfin git tree on Monday.

Thanks,
--Bob
