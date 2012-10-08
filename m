Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2JHWIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:08:45 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43955 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab2JHWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:08:42 -0400
MIME-Version: 1.0
In-Reply-To: <20121003161702.GA22008@kroah.com>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003132538.GE13192@linux.vnet.ibm.com>
	<20121003161702.GA22008@kroah.com>
Date: Mon, 8 Oct 2012 15:08:40 -0700
X-Google-Sender-Auth: _8aPs2pHU-jtg0072I0ww2zf_D4
Message-ID: <CAGXu5jL6N2qSokXFr17Re9DOneWx-+seSx7k_dk-A+0mgbOejQ@mail.gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 9:17 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Oct 03, 2012 at 06:25:38AM -0700, Paul E. McKenney wrote:
>> On Tue, Oct 02, 2012 at 12:50:42PM -0700, Kees Cook wrote:
>> > This config item has not carried much meaning for a while now and is
>> > almost always enabled by default. As agreed during the Linux kernel
>> > summit, it should be removed. As a first step, remove it from being
>> > listed, and default it to on. Once it has been removed from all
>> > subsystem Kconfigs, it will be dropped entirely.
>> >
>> > CC: Greg KH <gregkh@linuxfoundation.org>
>> > CC: "Eric W. Biederman" <ebiederm@xmission.com>
>> > CC: Serge Hallyn <serge.hallyn@canonical.com>
>> > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> > CC: Andrew Morton <akpm@linux-foundation.org>
>> > CC: Frederic Weisbecker <fweisbec@gmail.com>
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > ---
>> >
>> > This is the first of a series of 202 patches removing EXPERIMENTAL from
>> > all the Kconfigs in the tree. Should I send them all to lkml (with all
>> > the associated CCs), or do people want to cherry-pick changes from my
>> > tree? I don't want to needlessly flood the list.
>> >
>> > http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
>> >
>> > I figure this patch can stand alone to at least make EXPERIMENTAL go
>> > away from the menus, and give us a taste of what the removal would do
>> > to builds.
>>
>> OK, I will bite...  How should I flag an option that is initially only
>> intended for those willing to take some level of risk?
>
> In the text say "You really don't want to enable this option, use at
> your own risk!"  Or something like that :)

So, should I update the commit description to include a suggested
alternative? (If so, which one?)

Who is going to carry this initial patch, btw?

-Kees

-- 
Kees Cook
Chrome OS Security
