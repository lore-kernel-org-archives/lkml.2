Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1BUOIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:08:16 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:52012 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920Ab1BUOIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:08:15 -0500
Date: Mon, 21 Feb 2011 16:08:11 +0200
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <dacohen@gmail.com>
Cc: balbi@ti.com, Alexey Dobriyan <adobriyan@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
Message-ID: <20110221140811.GH23087@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1298283649-24532-1-git-send-email-dacohen@gmail.com>
 <1298283649-24532-2-git-send-email-dacohen@gmail.com>
 <AANLkTimwvgLvpvndCqcd_okA2Kk4cu7z4bD3QXTdgWJW@mail.gmail.com>
 <20110221123049.GC23087@legolas.emea.dhcp.ti.com>
 <AANLkTinc=ye2qZJ1esSta=xEGz_iEr73eg3qEES2S5P7@mail.gmail.com>
 <20110221135709.GG23087@legolas.emea.dhcp.ti.com>
 <AANLkTin6SY6oUd8j3dcvjoTrPn4P2XP=hX5S+D8s1J+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin6SY6oUd8j3dcvjoTrPn4P2XP=hX5S+D8s1J+g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 21, 2011 at 04:05:14PM +0200, David Cohen wrote:
> On Mon, Feb 21, 2011 at 3:57 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Feb 21, 2011 at 03:51:25PM +0200, Alexey Dobriyan wrote:
> >> > I rather have the split done and kill the circular dependency.
> >>
> >> It's not circular for starters.
> >
> > how come ? wait.h depends on sched and sched.h depends on wait.h
> 
> The tricky thing is wait.h doesn't depend on sched.h, but the file
> which uses wake_up*() macro defined on wait.h will depend on sched.h
> (what is still bad). wait.h should provide all dependencies to use a

That's why I say wait.h depends on sched.h because it uses a macro
defined in sched.h

-- 
balbi
