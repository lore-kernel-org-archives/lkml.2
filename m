Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab0KAN6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:58:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:58300 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390Ab0KAN6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:58:07 -0400
Date: Mon, 01 Nov 2010 22:57:58 +0900 (JST)
Message-Id: <20101101.225758.12584142.ryusuke@osrg.net>
To: trapdoor6@gmail.com
Cc: ramya.desai@gmail.com, horms@verge.net.au, linux-kernel@vger.kernel.org
Subject: Re: Where can I find -rc kernels?
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <AANLkTimqkGH3PMfyL02R9agaxbP9t+BzjqLUaPK=ynu8@mail.gmail.com>
References: <AANLkTinQ9NdEU+dp35sKp8u1tFu2NR2iX59wi-3wBFeH@mail.gmail.com>
	<AANLkTim=4GBFzMiAaGbs6uWbi1g2ZQGRYR55i4bO0X49@mail.gmail.com>
	<AANLkTimqkGH3PMfyL02R9agaxbP9t+BzjqLUaPK=ynu8@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 01 Nov 2010 22:57:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010 13:11:58 +0000, trapDoor <trapdoor6@gmail.com> wrote:
> On Mon, Nov 1, 2010 at 1:05 PM, trapDoor <trapdoor6@gmail.com> wrote:
> > On Mon, Nov 1, 2010 at 12:54 PM, Ramya Desai <ramya.desai@gmail.com> wrote:
> >> On Mon, Nov 1, 2010 at 5:46 PM, Simon Horman <horms@verge.net.au> wrote:
> >>>
> >>> Is this what you are after?
> >>>
> >>> http://www.kernel.org/pub/linux/kernel/v2.6/testing/
> >>
> >> Simon,
> >>
> >> I did not find the complete sources in that link. I need complete
> >> sources by which I can build the kernel images. OR Is there any
> >> procedure for merging these changes into any stable kernel version
> >> (2.6.36) for making it 2.6.37-rc1.
> >>
> >> Thanks and Regards,
> >> Ramya.
> >
> > I guess It just hasn't been published there yet. Not present in git
> > tree either - I still have 2.6.36-09871-g3985c7c and 'git pull' says:
> > Already up-to-date.
> >
> 
> It's out now at http://www.kernel.org/
> But still can't pull it from git.
> 
>
> -- 
> Thanks,
> Tomasz

v2.6.37-rc1 is in the git tree.

It looks like only master branch hasn't been updated yet.

Ryusuke Konishi 
