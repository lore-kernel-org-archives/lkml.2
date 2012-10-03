Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab2JCTIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:08:14 -0400
Received: from mail.lang.hm ([64.81.33.126]:56485 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab2JCTII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:08:08 -0400
Date: Wed, 3 Oct 2012 12:07:33 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Kees Cook <keescook@chromium.org>
cc: paulmck@linux.vnet.ibm.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
In-Reply-To: <CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210031202140.13407@asgard.lang.hm>
References: <20121002195042.GA16087@www.outflux.net> <20121003132538.GE13192@linux.vnet.ibm.com> <20121003161702.GA22008@kroah.com> <20121003164712.GF2527@linux.vnet.ibm.com> <CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Kees Cook wrote:

>>>> OK, I will bite...  How should I flag an option that is initially only
>>>> intended for those willing to take some level of risk?
>>>
>>> In the text say "You really don't want to enable this option, use at
>>> your own risk!"  Or something like that :)
>>
>> OK, so the only real hope for experimental features is to refrain from
>> creating a config option for them, so that people wishing to use them
>> must modify the code?  Or is the philosophy that we keep things out of
>> tree until we are comfortable with distros turning them on?
>
> I would expect a simple addition of "this is dangerous/buggy" to the
> description and "default n" is likely the way to go for that kind of
> thing. I think the history of CONFIG_EXPERIMENTAL has proven there
> isn't a sensible way to create a global flag for this kind of thing.
> To paraphrase Serge: my experimental options are not your experimental
> options.

Remember that new features/drivers should be defaulting to 'n' in any 
case. It's a rare feature that has no drawbacks (if only in the kernel 
size, which is an issue for small devices). If there really are no 
drawbacks to something, why have it be an option at all?

David Lang
