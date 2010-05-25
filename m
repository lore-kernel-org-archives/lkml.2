Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab0EYT6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:58:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44024 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab0EYT6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:58:09 -0400
Date: Tue, 25 May 2010 12:53:54 -0700
From: Randy Dunlap <randy.dunlap@Oracle.com>
To: "zhanglx" <zhanglx@semico.com.cn>
Cc: "Neil Brown" <neilb@suse.de>, "Nick W" <n60storm4@gmail.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: The Future of the Linux Kernel
Message-Id: <20100525125354.60f8a88c.randy.dunlap@oracle.com>
In-Reply-To: <01a101cafbdd$6fa10c10$3701a8c0@wxintech.com>
References: <AANLkTil8KvSojByVejgcPHIlVn9QOYmmCAfQwpb4XT5E@mail.gmail.com>
	<20100525165152.1ecfadd4@notabene.brown>
	<017601cafbd9$30924dd0$3701a8c0@wxintech.com>
	<20100525172218.79e3d325@notabene.brown>
	<01a101cafbdd$6fa10c10$3701a8c0@wxintech.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BFC2AF1.00B3:SCFMA922111,ss=1,pt=113351,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 15:39:40 +0800 zhanglx wrote:

> I will not say interest or no interest on Linux kernel. I just want to know how it runs on earth because a lot of talent people working on it. :)
> 
> I do not know how to submit patches. Is it processed by GIT tool?


It can be processed by git, but that is not required.

The Documentation/ subdirectory in the kernel tree contains these files
that should help you:

SubmittingPatches
SubmittingDrivers
SubmitChecklist


> ----- Original Message ----- 
> From: "Neil Brown" <neilb@suse.de>
> To: "zhanglx" <zhanglx@semico.com.cn>
> Cc: "Nick W" <n60storm4@gmail.com>; <linux-kernel@vger.kernel.org>
> Sent: Tuesday, May 25, 2010 3:22 PM
> Subject: Re: The Future of the Linux Kernel
> 
> 
> > On Tue, 25 May 2010 15:09:17 +0800
> > "zhanglx" <zhanglx@semico.com.cn> wrote:
> > 
> >> Good answer, the future is determined by now.
> >> But the kernel is very complex. It's too difficult for beginners. :(
> > 
> > We were all beginners once!
> > Yes, the kernel is much more complex than it once was, so understanding a
> > whole subsystem is a more daunting task than it once was.  But there is still
> > room to start.  www.kernelnewbies.org/  is supposed to be a good place to
> > start.
> > 
> > We all learn to read before we can write.  I recommend the same with the
> > kernel.  Read lots of code, improve the documentation as you go, submit
> > little patches for little bugs that you find, get interested, build courage,
> > see where you end up.
> > 
> > NeilBrown
> > 
> > 
> >> 
> >> ----- Original Message ----- 
> >> From: "Neil Brown" <neilb@suse.de>
> >> To: "Nick W" <n60storm4@gmail.com>
> >> Cc: <linux-kernel@vger.kernel.org>
> >> Sent: Tuesday, May 25, 2010 2:51 PM
> >> Subject: Re: The Future of the Linux Kernel
> >> 
> >> 
> >> > On Tue, 25 May 2010 18:34:36 +1200
> >> > Nick W <n60storm4@gmail.com> wrote:
> >> > 
> >> >> Hi guys I am new to the LKML so Hi! Anyway I think the Linux Kernel is
> >> >> great! (Love C development on anything what so ever!) But what do you
> >> >> think the future of it is? Please can you guys have a think and we can
> >> >> decide!
> >> > 
> >> > Yes said that already... if you are going to say it again at least you could
> >> > try saying it differently.
> >> > 
> >> > We don't plan and decide the future.  We create possible small steps
> >> > into the future and see if they survive testing and peer-review.  The future
> >> > we end up with is simple the sum of lots of these small steps.
> >> > 
> >> > What would *you* like the future to be?  Please answer in the form of a patch.
> >> > 
> >> > NeilBrown
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> > Please read the FAQ at  http://www.tux.org/lkml/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
