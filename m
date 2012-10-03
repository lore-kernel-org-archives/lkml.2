Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab2JCQoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:44:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47110 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab2JCQn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:43:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKQ=fiOTE+WMZhL2a_Fbt+9QkvAuns5OveznnOMx-RrAQ@mail.gmail.com>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003132538.GE13192@linux.vnet.ibm.com>
	<CAGXu5jKQ=fiOTE+WMZhL2a_Fbt+9QkvAuns5OveznnOMx-RrAQ@mail.gmail.com>
Date: Wed, 3 Oct 2012 12:43:57 -0400
Message-ID: <CA+5PVA5srR1uuAvFKKzDUS7SEYDZOdonG1f1GsNA_nmwuhjx-A@mail.gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
From: Josh Boyer <jwboyer@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 12:15 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Oct 3, 2012 at 6:25 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
>> On Tue, Oct 02, 2012 at 12:50:42PM -0700, Kees Cook wrote:
>>> This config item has not carried much meaning for a while now and is
>>> almost always enabled by default. As agreed during the Linux kernel
>>> summit, it should be removed. As a first step, remove it from being
>>> listed, and default it to on. Once it has been removed from all
>>> subsystem Kconfigs, it will be dropped entirely.
>>>
>>> CC: Greg KH <gregkh@linuxfoundation.org>
>>> CC: "Eric W. Biederman" <ebiederm@xmission.com>
>>> CC: Serge Hallyn <serge.hallyn@canonical.com>
>>> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>>> CC: Andrew Morton <akpm@linux-foundation.org>
>>> CC: Frederic Weisbecker <fweisbec@gmail.com>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>
>>> This is the first of a series of 202 patches removing EXPERIMENTAL from
>>> all the Kconfigs in the tree. Should I send them all to lkml (with all
>>> the associated CCs), or do people want to cherry-pick changes from my
>>> tree? I don't want to needlessly flood the list.
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
>>>
>>> I figure this patch can stand alone to at least make EXPERIMENTAL go
>>> away from the menus, and give us a taste of what the removal would do
>>> to builds.
>>
>> OK, I will bite...  How should I flag an option that is initially only
>> intended for those willing to take some level of risk?
>
> I'm not sure I understand what you mean? The intention of removing
> EXPERIMENTAL is effectively like turning it on everywhere, so this
> first patch does that. As we go forward we can remove the its
> redundant use in all the Kconfigs, until it is finally removed for
> real.

He's asking "how do I add a feature/option into Linus' tree that I'm
really not ready for random people and/or distros to enable".  The
short answer is "don't merge that into Linus' tree" I guess.  Keep it
in a git branch or patchset somewhere else.  Perhaps those willing to
take the risk are also willing to apply the patches?

josh
