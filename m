Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1KQIoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:44:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49210 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1KQIom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:44:42 -0500
Date: Thu, 17 Nov 2011 16:44:35 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] lockdep: print lock name for lockdep_init_error
Message-ID: <20111117084435.GA16757@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1321508072-23853-1-git-send-email-tom.leiming@gmail.com>
 <1321508072-23853-2-git-send-email-tom.leiming@gmail.com>
 <20111117060215.GB15644@zhy>
 <CACVXFVPo410dy5Mz_Kd3vC=iLazgg8MuPpHnMKfUbUypfXaGUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACVXFVPo410dy5Mz_Kd3vC=iLazgg8MuPpHnMKfUbUypfXaGUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 04:01:16PM +0800, Ming Lei wrote:
> Hi,
> 
> Thanks for your review.
> 
> On Thu, Nov 17, 2011 at 2:02 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Thu, Nov 17, 2011 at 01:34:32PM +0800, tom.leiming@gmail.com wrote:
> >> From: Ming Lei <tom.leiming@gmail.com>
> >>
> >> This patch prints the name of the lock which is acquired
> >> before lockdep_init is called, so that user can easily find
> >> which lock trigged the lockdep init error warning.
> >
> > Should we care about that?
> 
> Yes, we should, see below.
> 
> >
> > I think lockdep_init() called early enough give more hint.
> > Such as be the first C function called by arch.
> 
> Maybe not early enough, before start_kernel is executed, arch
> asm code still can call some C function, can't it?

To me that still means 'Arch code didn't call lockdep_init()
early enough'.

But anyway, let Peter/Ingo decide it.

Thanks,
Yong
