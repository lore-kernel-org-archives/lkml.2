Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab0K2CNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:13:04 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56334 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0K2CND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:13:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=OpLcfvfBOR122dQUgDAe8wgH9AXJkfMGobmOOqEPSrub0cGucMJFiL/M/42XIT4ez0
         1uon/4v00rchqUsqQcxvvFDtIdZ+l2M/wUP2SeSvBOcfIHaZ96ZDCIby6Yg6TNWyhHRZ
         vt7nWMKgTT/wtquGT9Ob2Uy+VffSpbwSV9UwQ=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <4CF3081B.9090307@gmail.com>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	 <1290951770.13526.18.camel@cai.gentoo>
	 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	 <20101129020610.7ea7c79e.lisa@ltmnet.com>
	 <1290961207.13526.31.camel@cai.gentoo> <20101128194624.GP2767@thunk.org>
	 <4CF3081B.9090307@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Mon, 29 Nov 2010 10:14:06 +0800
Message-ID: <1290996846.877.23.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-29一的 04:55 +0300，Alexey Gladkov写道：
> 28.11.2010 22:46, Ted Ts'o wrote:
> > How many people do regular login, development, reading e-mail, etc.,
> > on the console?  Very few!
> 
> Once I broke the euro symbol in the kbd keymaps and got a kick in the
> ass very quickly :). It means that users continue to use the console
> quite active.
> 
> Another example: I keep getting a new keymaps and console fonts for
> each new kbd release.
> 
> Maybe not a lot of console users, but more of them than you think.
> 
> > If the answer is because you hate X, as
> > you've already pointed out, we already have fbterm.  Where is it
> > written that we need to have a full unicode-capable console system?
> 
> fbterm ‎can't help in all cases. For example: we have a limitation
> NR_KEYS, which makes it impossible to use keycode > 256 in keymaps.
> I've already received several complaints about it.
> 

YES, user-space can't always fit! Some function need to be implemented
in kernel. And that's why we have KMS, we have auto cgroup ....

Don't say, hey , hard to implement, all you have to to is apply the
path .. No need to do for you.

If the patch isn't as good as you expected, reject, I'll try better one.
The thing is, you really should agree that, implementing UNICODE font in
kernel isn't a bad idea.



