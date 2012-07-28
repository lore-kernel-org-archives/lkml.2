Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab2G1Bxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 21:53:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59493 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2G1Bxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 21:53:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120728012632.GA1766@lizard>
References: <20120726142514.GA32158@lizard>
	<CAMbhsRSM3QwwVfUMBWq1bDJxHX+Ox2CQtbvJVmemuMWjxfmDoQ@mail.gmail.com>
	<20120728012632.GA1766@lizard>
Date: Fri, 27 Jul 2012 18:53:30 -0700
Message-ID: <CAMbhsRQgFs0jQi_n_a89vbVgOjYXD-vd7tadHVtpuy026m39Vw@mail.gmail.com>
Subject: Re: [PATCH 0/7] KDB: Kiosk (reduced capabilities) mode
From: Colin Cross <ccross@google.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 6:26 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
<snip long rant>

> But if you say that it wasn't the case, and no one thought about the
> reducing the debugger in the "evil" way, so be it, I trust you. But I
> still don't trust the phone vendors. They showed their bad attitude
> in many ways towards hackers, so I think we both have quite legitimate
> reasons to be a little bit paranoid. :-)

I've never seen a non-Nexus phone that used the FIQ debugger, and I
believe every Nexus device has supported rooting.  We leave the FIQ
debugger enabled on the devices we personally carry because it allows
easy debugging without compromising our data, and we leave it enabled
on production devices (and leave the serial console muxed out the
headphone jack) because it's more useful to end users than a blank
serial console.

>> An alternate option would be to allow userspace to write a password
>> hash to a sysfs file, and require the password to be entered over the
>> serial console to unlock KGDB or enable unsafe KGDB commands.
>
> Yup, that's a very nice idea. This can be implemented by introducing
> "unlock" KDB command. Although, that also requires tight integration
> w/ user-space, i.e. on boot userland would need to supply hashing
> method, salt and root's password hash. The same has to be done on every
> password change. It is surely doable, but not sure if it is worth the
> efforts. Maybe, some day.
>
> Thanks,
>
> --
> Anton Vorontsov
> Email: cbouatmailru@gmail.com
