Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0L3ACT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 19:02:19 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:41272 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754284Ab0L3ACS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 19:02:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TP9NGQDvt40M12AOBjmRP9Z3itwI26vToXkqjBTuYfDVPqOres/MJXXHSvCIq0oNHrKzyigkLUVTiHBhvRChUBvPK62ThS8Xf9UVkNTRdpagwG0XGDXioCXaH98RjdcT;
Date: Wed, 29 Dec 2010 16:02:15 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Message-ID: <20101229160215.1a67d71a@jbarnes-desktop>
In-Reply-To: <AANLkTim51EAwzUqSJGQ4LnJbbPNCqbhyJumUd=_WkB+T@mail.gmail.com>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
	<AANLkTikMMpdMr66n-VL9xdNVhmGMaWR74UdF5UB7cdCW@mail.gmail.com>
	<20101229131852.0792aac0@jbarnes-desktop>
	<20101229135315.5fe5c4e5@jbarnes-desktop>
	<AANLkTikk3Z_p+-uRB4iF8CUuMAyuKVtPbuht=hQOm2uH@mail.gmail.com>
	<20101229151323.4a675097@jbarnes-desktop>
	<AANLkTim=NTUtuAG=Gk=GeBHfTNM73xw6F8gjry6xsHs7@mail.gmail.com>
	<AANLkTim51EAwzUqSJGQ4LnJbbPNCqbhyJumUd=_WkB+T@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010 00:35:15 +0100
Alex Riesen <raa.lkml@gmail.com> wrote:

> On Thu, Dec 30, 2010 at 00:20, Alex Riesen <raa.lkml@gmail.com> wrote:
> > On Thu, Dec 30, 2010 at 00:13, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >>> After closing and opening the lid (displays backlight is back)
> >>>
> >>>   http://vin-soft.org/~raa/public/test/intel_gpu_dump-after-lid
> >>
> >> I need the intel_reg_dumper output, not intel_gpu_dump. :)
> >>
> >
> > Hmm, there is no intel_reg_dumper in intel-gpu-tools-1.0.2, which is
> > the latest on http://xorg.freedesktop.org/archive/individual/app/,
> > so I assumed you just mistyped the name. Is it in git only? ...
> > Yeah, look like it is in git only, which I have problems to compile
> > (I have a bit of obsoleted system).
> >
> 
> Is there any other way to get at the dump? Because it looks like
> it is plainly impossible to build the tools. A lot of dependencies,
> all really hard to get at on Ubuntu Jaunty.

That's the easiest way; I think there are existing packages available
as well, but you may have to check Karmic or newer.

-- 
Jesse Barnes, Intel Open Source Technology Center
