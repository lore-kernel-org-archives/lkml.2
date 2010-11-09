Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0KISky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:40:54 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:41781 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753253Ab0KISkx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:40:53 -0500
MIME-Version: 1.0
In-Reply-To: <20101109175828.GA27627@kroah.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
	<AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
	<201011091729.17679.arnd@arndb.de>
	<20101109165509.GA9698@kroah.com>
	<AANLkTinFW431t9XFqHc=wZAws9gjT0ikrc03J83kH7iF@mail.gmail.com>
	<20101109172511.GA10958@kroah.com>
	<AANLkTi=CKERMcSLXwQa7G55P69DO--UPN9HgOScHP_yO@mail.gmail.com>
	<20101109175828.GA27627@kroah.com>
Date: Tue, 9 Nov 2010 12:40:51 -0600
Message-ID: <AANLkTimDUx-by0MStp3O0L0xGW-okdCqAbDrJHuCewd7@mail.gmail.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Greg KH <greg@kroah.com>
Cc: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Seriously, I'm getting very confused here, and am very annoyed by the
> whole thing.
>
> Here's what I don't like:
>  - the original driver didn't even seem to work properly
>  - people sent me patches they never tested and broke things even worse
>  - some people have no respect for the omap maintainers and what they
>    think about things, or even basic knowledge of the kernel
>    development cycle.
>  - I do not have this hardware so I can't test anything.
>
> So, from now on, I'm not taking ANYONES patches for this driver unless
> it gets an ack from the driver maintainer, Omar Luna.
>
> Actually, no, I'm not going to take any patch unless it _comes from_
> Omar.  Omar, please work to queue up patches and test them, and then
> send them to me for merging.
>
> Any questions?
>
> If anyone doesn't like this because they feel that the current driver is
> broken, well, I can easily solve that by just deleting the whole thing
> from the tree right now.  Would that be a better idea?

I'm fine to queue the patches.

For now, yes, the driver is/has-been broken, and everybody has been
trying for the last two cycles to fix some dependencies (and
unfortunately we do it at the last minute or even after it can't be
done anymore, *sometimes*)... I have been kindly educated by both LO
and staging tree maintainers that it is just a bad practice to hurry
things up and not comply with the development standards.

If 2.6.36 or .37 tidspbridge is needed I'll keep each branch with
their dependent patches in d.o-z (TI's git server), if anybody
(Felipe) wants to keep their own branches I'm fine with that I can
sync with them privately to hear any concerns or something else.

I'll create the branches and sent an announce to both lists.

All dependencies need to be acked long before 2.6.38-rc1 and it is the
responsibility of the senders to track their acceptance.

Thanks for your suggestions and bearing with this situation, I'll
follow them and solve your dislikes about it (the hardware part it
might not be possible :/).

BTW, the testing environment for tidspbridge will be gst-dsp, any
stress testsuites will be run in addition, I'll detail more of it in
the upcoming mail.

Regards,

Omar
