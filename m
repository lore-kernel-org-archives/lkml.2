Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0K2Bzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:55:46 -0500
Received: from mojo.unsafe.ru ([83.222.2.183]:31508 "EHLO mojo.unsafe.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0K2Bzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:55:45 -0500
Message-ID: <4CF3081B.9090307@gmail.com>
Date: Mon, 29 Nov 2010 04:55:39 +0300
From: Alexey Gladkov <gladkov.alexey@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9pre) Gecko/20100817 Lightning/1.0b2pre Thunderbird/3.1.3pre
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Microcai <microcai@fedoraproject.org>,
        Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
References: <1290941875.13526.15.camel@cai.gentoo> <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu> <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com> <20101129020610.7ea7c79e.lisa@ltmnet.com> <1290961207.13526.31.camel@cai.gentoo> <20101128194624.GP2767@thunk.org>
In-Reply-To: <20101128194624.GP2767@thunk.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

28.11.2010 22:46, Ted Ts'o wrote:
> How many people do regular login, development, reading e-mail, etc.,
> on the console?  Very few!

Once I broke the euro symbol in the kbd keymaps and got a kick in the
ass very quickly :). It means that users continue to use the console
quite active.

Another example: I keep getting a new keymaps and console fonts for
each new kbd release.

Maybe not a lot of console users, but more of them than you think.

> If the answer is because you hate X, as
> you've already pointed out, we already have fbterm.  Where is it
> written that we need to have a full unicode-capable console system?

fbterm ‎can't help in all cases. For example: we have a limitation
NR_KEYS, which makes it impossible to use keycode > 256 in keymaps.
I've already received several complaints about it.

-- 
Rgrds, legion

