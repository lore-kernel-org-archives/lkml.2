Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab1IIVOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:14:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53509 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1IIVOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:14:20 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1109092245170.9242@ask.diku.dk>
References: <CAB=NE6U0ks9CobukO04=bZpnkm3Yw+Pf7keVPsP-hv1NyJZ_Xw@mail.gmail.com>
 <Pine.LNX.4.64.1109092245170.9242@ask.diku.dk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 9 Sep 2011 14:13:59 -0700
Message-ID: <CAB=NE6VVaAgyaEX0iTuuj=r1-Vsi5TgAyCj4+3J=QerrJTWs_Q@mail.gmail.com>
Subject: Re: Backporting the Linux kernel, for good - was: Re: semantic patch inference
To: Julia Lawall <julia@diku.dk>
Cc: Jesper Andersen <jespera@diku.dk>, Hauke Mehrtens <hauke@hauke-m.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 1:48 PM, Julia Lawall <julia@diku.dk> wrote:
> Thanks for your email.  It made me realize that there was one thing that I
> didn't understand at all.  If the patches are only intended to apply to
> linux-next, that makes the problem quite a bit simpler.

Awesome, and yes the patches/ are only targeted at applying onto
linux-next.git. When Linus decides to merge and out 3.x-rc1 I simply
then set $GIT_TREE to $HOME/linux-2.6-allstable/ and run the script to
suck code from there and apply patches from there.Turns out that
because the effort was done on linux-next and because linux-next will
look very much like what Linus ends up merging the patches/ will still
apply. So what I do then is simply create a branch for that target
stable kernel and keep refreshing the patches for that stable kernel
on that branch -- while the master branch keeps chugging along with
linux-next.

> I guess that the patch that spdiff will receive will already contain the
> appropriate #ifs, so we don't have to be concerned about them.

That is correct.

> We just add them in as is.

I do not follow, add what?

> There was also the question about one or multiple types of changes.  I
> think this is not a problem, but Jesper should confirm.  If a patch contains
> two changes and one can be generalized and the other one cannot for some
> reason, does spdiff give up on the whole thing, or does it do what it can?
>
> Overall, the whole thing seems to be doable :)

Wow. I'm thrilled, so say the least.

  Luis
