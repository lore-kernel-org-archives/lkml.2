Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0L2XN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:13:29 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:50673 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750790Ab0L2XN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:13:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LClrHECrl5k5udtnGWOgutbl2UhO7dIcWHS0/0/vChFOVoZBOMHIYDrImBopzNDBvHbxOSR/kS5Wbnt9FVWS5F6qJPmFUM3GA90+YlCs/K1Ug7i8JYJ9q/YF2RexK70y;
Date: Wed, 29 Dec 2010 15:13:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Message-ID: <20101229151323.4a675097@jbarnes-desktop>
In-Reply-To: <AANLkTikk3Z_p+-uRB4iF8CUuMAyuKVtPbuht=hQOm2uH@mail.gmail.com>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
	<AANLkTikMMpdMr66n-VL9xdNVhmGMaWR74UdF5UB7cdCW@mail.gmail.com>
	<20101229131852.0792aac0@jbarnes-desktop>
	<20101229135315.5fe5c4e5@jbarnes-desktop>
	<AANLkTikk3Z_p+-uRB4iF8CUuMAyuKVtPbuht=hQOm2uH@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010 00:09:56 +0100
Alex Riesen <raa.lkml@gmail.com> wrote:

> On Wed, Dec 29, 2010 at 22:53, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >> > Doesn't change anything here. Display stays blank.
> >>
> >> Sounds like your problem is separate from SSC then, more likely related
> >> to panel power or backlight control.  Have you tried bisecting for the
> >> problem between 2.6.35 and 2.6.36?
> >
> > Nevermind, I just checked out the bug, looks like it is panel power
> > related.  Can you try this patch?
> 
> Tried. Does not work.
> 
> > If it doesn't work, can you send me the output of intel_reg_dumper from
> > before you turn off the display and after you try to turn it back on?
> 
> See the links below (sorry, they files are a bit large):
> 
> Before running "xset dpms force standby":
> 
>   http://vin-soft.org/~raa/public/test/intel_gpu_dump-before
> 
> After running "sleep 3"
> 
>   http://vin-soft.org/~raa/public/test/intel_gpu_dump-after-suspend
> 
> After running "xset dpms force on"
> 
>   http://vin-soft.org/~raa/public/test/intel_gpu_dump-after-xset-on
> 
> After closing and opening the lid (displays backlight is back)
> 
>   http://vin-soft.org/~raa/public/test/intel_gpu_dump-after-lid

I need the intel_reg_dumper output, not intel_gpu_dump. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
