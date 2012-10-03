Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab2JCXdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:33:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39820 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab2JCXdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <20121003232923.GA21374@roeck-us.net>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003232923.GA21374@roeck-us.net>
Date: Wed, 3 Oct 2012 16:33:21 -0700
X-Google-Sender-Auth: YjAs31ciKhB4VVNFaoVGpbhfzBQ
Message-ID: <CAGXu5jJsGJCNtSK8W_XGGcN1BqOEsH84dTuBSs2Fo5EuBLUNMg@mail.gmail.com>
Subject: Re: make CONFIG_EXPERIMENTAL invisible and default
From: Kees Cook <keescook@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 4:29 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Tue, Oct 02, 2012 at 07:50:42PM -0000, Kees Cook wrote:
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
>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>>
>> ---
>> This is the first of a series of 202 patches removing EXPERIMENTAL from
>> all the Kconfigs in the tree. Should I send them all to lkml (with all
>> the associated CCs), or do people want to cherry-pick changes from my
>> tree? I don't want to needlessly flood the list.
>>
>> http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
>>
> I cherry-picked the hwmon/pmbus patch (commit 41c5b6bb).

Great, thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
