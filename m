Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2JIAqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 20:46:13 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:34246 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2JIAqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:46:10 -0400
MIME-Version: 1.0
In-Reply-To: <20121008235344.GC8157@kroah.com>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003132538.GE13192@linux.vnet.ibm.com>
	<20121003161702.GA22008@kroah.com>
	<CAGXu5jL6N2qSokXFr17Re9DOneWx-+seSx7k_dk-A+0mgbOejQ@mail.gmail.com>
	<20121008235344.GC8157@kroah.com>
Date: Mon, 8 Oct 2012 17:46:08 -0700
X-Google-Sender-Auth: jPRCUXjL-0GGbludRgYNoAb_Ni4
Message-ID: <CAGXu5jLUpcd-g0OM0i_1O38QWCWmw=PNfobtaLm0XduY45Ou6Q@mail.gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 4:53 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 08, 2012 at 03:08:40PM -0700, Kees Cook wrote:
>> On Wed, Oct 3, 2012 at 9:17 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Oct 03, 2012 at 06:25:38AM -0700, Paul E. McKenney wrote:
>> >> On Tue, Oct 02, 2012 at 12:50:42PM -0700, Kees Cook wrote:
>> >> > This config item has not carried much meaning for a while now and is
>> >> > almost always enabled by default. As agreed during the Linux kernel
>> >> > summit, it should be removed. As a first step, remove it from being
>> >> > listed, and default it to on. Once it has been removed from all
>> >> > subsystem Kconfigs, it will be dropped entirely.
>> >> >
>> >> > CC: Greg KH <gregkh@linuxfoundation.org>
>> >> > CC: "Eric W. Biederman" <ebiederm@xmission.com>
>> >> > CC: Serge Hallyn <serge.hallyn@canonical.com>
>> >> > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> >> > CC: Andrew Morton <akpm@linux-foundation.org>
>> >> > CC: Frederic Weisbecker <fweisbec@gmail.com>
>> >> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> >> > ---
>> >> >
>> >> > This is the first of a series of 202 patches removing EXPERIMENTAL from
>> >> > all the Kconfigs in the tree. Should I send them all to lkml (with all
>> >> > the associated CCs), or do people want to cherry-pick changes from my
>> >> > tree? I don't want to needlessly flood the list.
>> >> >
>> >> > http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
>> >> >
>> >> > I figure this patch can stand alone to at least make EXPERIMENTAL go
>> >> > away from the menus, and give us a taste of what the removal would do
>> >> > to builds.
>> >>
>> >> OK, I will bite...  How should I flag an option that is initially only
>> >> intended for those willing to take some level of risk?
>> >
>> > In the text say "You really don't want to enable this option, use at
>> > your own risk!"  Or something like that :)
>>
>> So, should I update the commit description to include a suggested
>> alternative? (If so, which one?)
>
> Which do you prefer?

I think developers that want something harder that strongly worded
text in the Kconfig title or description should throw a printk.

>> Who is going to carry this initial patch, btw?
>
> You?  :)

Do you mean to say I should ask Stephen to pull from one of my trees
for linux-next? If so, I've made this now:

git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git linux-next

-Kees

-- 
Kees Cook
Chrome OS Security
