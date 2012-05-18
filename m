Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968233Ab2ERX4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:56:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36357 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965463Ab2ERX4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:56:40 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxXrX5QboJXYDM2G0sG3xf4Fx19snaMgPRknRsmTOJRKg@mail.gmail.com>
References: <CACxGe6vuA9A6X5qBt+maej2vaJCgLcHvYfqfXRGD+sKAYt4Bnw@mail.gmail.com>
 <CA+55aFxXrX5QboJXYDM2G0sG3xf4Fx19snaMgPRknRsmTOJRKg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 May 2012 17:56:19 -0600
X-Google-Sender-Auth: zMQ23cfCK6Eh85xAJnXbV-zWL0E
Message-ID: <CACxGe6uNo4Q9Na=4X3SuzVc34uS_cRn_NY_V5AhZD_A=6_of1w@mail.gmail.com>
Subject: Re: [GIT PULL] GPIO build failure bug fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 5:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, May 18, 2012 at 1:04 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> GPIO build failure bug
>>
>> The gpio pch9 patch merged for v3.4-rc7 has a build failure when built
>> as a module because it is an interrupt controller and the symbols it
>> needs aren't exported.  This branch restricts it to being built in to
>> solve the issue until it can be fixed properly in v3.5.
>
> Umm.  They got exported by commit 3911ff30f5d1. So this bugfix seems stale.
>
> Or is there something else going on too?

Just lack of coordination.  Please ignore this pull; it is indeed fixed.

g.
