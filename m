Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2JIGBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:01:37 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62491 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab2JIGBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:01:35 -0400
MIME-Version: 1.0
In-Reply-To: <20121009134737.cd3da4d85beeb97b1cb88d92@canb.auug.org.au>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003132538.GE13192@linux.vnet.ibm.com>
	<20121003161702.GA22008@kroah.com>
	<CAGXu5jL6N2qSokXFr17Re9DOneWx-+seSx7k_dk-A+0mgbOejQ@mail.gmail.com>
	<20121008235344.GC8157@kroah.com>
	<CAGXu5jLUpcd-g0OM0i_1O38QWCWmw=PNfobtaLm0XduY45Ou6Q@mail.gmail.com>
	<20121009012610.GA3446@linux.vnet.ibm.com>
	<CAGXu5jLZH=VNU=ZaJRzFJxERBJEV1XkUfAqWK+6j8knOzua_Gw@mail.gmail.com>
	<20121009134737.cd3da4d85beeb97b1cb88d92@canb.auug.org.au>
Date: Mon, 8 Oct 2012 23:01:34 -0700
X-Google-Sender-Auth: Av7jxu1dw2iNKmuNO9LGn_MhZAU
Message-ID: <CAGXu5jLG1+tGXaDyedV08QPozF6gTnCZNmWrD=QK5FyhASCRJQ@mail.gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
From: Kees Cook <keescook@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: paulmck@linux.vnet.ibm.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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

On Mon, Oct 8, 2012 at 7:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Kees,
>
> On Mon, 8 Oct 2012 18:57:51 -0700 Kees Cook <keescook@chromium.org> wrote:
>>
>> On Mon, Oct 8, 2012 at 6:20 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Mon, Oct 08, 2012 at 05:46:08PM -0700, Kees Cook wrote:
>> >> On Mon, Oct 8, 2012 at 4:53 PM, Greg Kroah-Hartman
>> >> <gregkh@linuxfoundation.org> wrote:
>> >> > On Mon, Oct 08, 2012 at 03:08:40PM -0700, Kees Cook wrote:
>> >> >> Who is going to carry this initial patch, btw?
>> >> >
>> >> > You?  :)
>> >>
>> >> Do you mean to say I should ask Stephen to pull from one of my trees
>> >> for linux-next? If so, I've made this now:
>> >>
>> >> git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git linux-next
>> >
>> > Sounds good to me, good luck.
>>
>> Stephen, can you add this tree to your pulls for linux-next?
>
> For this single commit, if you want it to go in during this merge window,
> I suggest you send it as a patch to Linus.    If there is going to be
> ongoing work on this topic, then I will be happy to add your tree after
> v3.7-rc1 is released (since the further work should be destined for v3.8,
> right?).

I'm intending it for 3.8, so waiting is fine.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
