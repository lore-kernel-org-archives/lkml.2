Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab0EYHW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:22:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab0EYHW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:22:27 -0400
Date: Tue, 25 May 2010 17:22:18 +1000
From: Neil Brown <neilb@suse.de>
To: "zhanglx" <zhanglx@semico.com.cn>
Cc: "Nick W" <n60storm4@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: The Future of the Linux Kernel
Message-ID: <20100525172218.79e3d325@notabene.brown>
In-Reply-To: <017601cafbd9$30924dd0$3701a8c0@wxintech.com>
References: <AANLkTil8KvSojByVejgcPHIlVn9QOYmmCAfQwpb4XT5E@mail.gmail.com>
	<20100525165152.1ecfadd4@notabene.brown>
	<017601cafbd9$30924dd0$3701a8c0@wxintech.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 15:09:17 +0800
"zhanglx" <zhanglx@semico.com.cn> wrote:

> Good answer, the future is determined by now.
> But the kernel is very complex. It's too difficult for beginners. :(

We were all beginners once!
Yes, the kernel is much more complex than it once was, so understanding a
whole subsystem is a more daunting task than it once was.  But there is still
room to start.  www.kernelnewbies.org/  is supposed to be a good place to
start.

We all learn to read before we can write.  I recommend the same with the
kernel.  Read lots of code, improve the documentation as you go, submit
little patches for little bugs that you find, get interested, build courage,
see where you end up.

NeilBrown


> 
> ----- Original Message ----- 
> From: "Neil Brown" <neilb@suse.de>
> To: "Nick W" <n60storm4@gmail.com>
> Cc: <linux-kernel@vger.kernel.org>
> Sent: Tuesday, May 25, 2010 2:51 PM
> Subject: Re: The Future of the Linux Kernel
> 
> 
> > On Tue, 25 May 2010 18:34:36 +1200
> > Nick W <n60storm4@gmail.com> wrote:
> > 
> >> Hi guys I am new to the LKML so Hi! Anyway I think the Linux Kernel is
> >> great! (Love C development on anything what so ever!) But what do you
> >> think the future of it is? Please can you guys have a think and we can
> >> decide!
> > 
> > Yes said that already... if you are going to say it again at least you could
> > try saying it differently.
> > 
> > We don't plan and decide the future.  We create possible small steps
> > into the future and see if they survive testing and peer-review.  The future
> > we end up with is simple the sum of lots of these small steps.
> > 
> > What would *you* like the future to be?  Please answer in the form of a patch.
> > 
> > NeilBrown
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
