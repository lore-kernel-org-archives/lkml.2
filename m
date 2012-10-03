Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab2JCQPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:15:38 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:65440 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab2JCQPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:15:36 -0400
MIME-Version: 1.0
In-Reply-To: <20121003132538.GE13192@linux.vnet.ibm.com>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003132538.GE13192@linux.vnet.ibm.com>
Date: Wed, 3 Oct 2012 09:15:35 -0700
X-Google-Sender-Auth: LNEtfOMn5QbtD4pW6bZRCCEFi70
Message-ID: <CAGXu5jKQ=fiOTE+WMZhL2a_Fbt+9QkvAuns5OveznnOMx-RrAQ@mail.gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
From: Kees Cook <keescook@chromium.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 6:25 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Oct 02, 2012 at 12:50:42PM -0700, Kees Cook wrote:
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, it should be removed. As a first step, remove it from being
>> listed, and default it to on. Once it has been removed from all
>> subsystem Kconfigs, it will be dropped entirely.
>>
>> CC: Greg KH <gregkh@linuxfoundation.org>
>> CC: "Eric W. Biederman" <ebiederm@xmission.com>
>> CC: Serge Hallyn <serge.hallyn@canonical.com>
>> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>
>> This is the first of a series of 202 patches removing EXPERIMENTAL from
>> all the Kconfigs in the tree. Should I send them all to lkml (with all
>> the associated CCs), or do people want to cherry-pick changes from my
>> tree? I don't want to needlessly flood the list.
>>
>> http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
>>
>> I figure this patch can stand alone to at least make EXPERIMENTAL go
>> away from the menus, and give us a taste of what the removal would do
>> to builds.
>
> OK, I will bite...  How should I flag an option that is initially only
> intended for those willing to take some level of risk?

I'm not sure I understand what you mean? The intention of removing
EXPERIMENTAL is effectively like turning it on everywhere, so this
first patch does that. As we go forward we can remove the its
redundant use in all the Kconfigs, until it is finally removed for
real.

-Kees

-- 
Kees Cook
Chrome OS Security
