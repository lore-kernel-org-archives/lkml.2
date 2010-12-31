Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab0LaGcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 01:32:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62355 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0LaGcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 01:32:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MIUyjwQK1sxe2fEvYXAOZkxBbcP1Ts+FVNUgNP1yTcpMhd/GzRCfG6yl2thwjjvJPC
         oZ9672Un7ubz9/w+kEsJVo3b/NA4f/yknfOcCirjkkkk3Lh2Q7F/tTDBCuu80mRVtGYw
         rdon3zkJKD0zjT+bKfKi39Z1Pjbw86tKmWSQ8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1012270640240.3071@localhost6.localdomain6>
References: <alpine.DEB.2.00.1012270640240.3071@localhost6.localdomain6>
Date: Fri, 31 Dec 2010 08:32:08 +0200
Message-ID: <AANLkTiktLCVQgGPCyt-fwVSkVmr8Ljr08UmvtkNG_zdp@mail.gmail.com>
Subject: Re: is there a fix for ubuntu with intel GPU booting to blank screen?
From: Anca Emanuel <anca.emanuel@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Ubuntu kernel team mailing list <kernel-team@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 1:50 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>
>  i've posted on a couple other lists but i figured i'd ask the
> experts.  on my updated/upgraded ubuntu system (gateway NV79 with
> intel GPU), i've built my own kernel from the latest linus git tree as
> i've done many times in the past, but this kernel boots to a blank
> screen.  here's a reference that seems to nicely summarize my
> situation:
>
>  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/561802
>
>  weirdly, i'm currently running an earlier "rc" hand-rolled git
> kernel which works fine:
>
> $ uname -a
> Linux lynx 2.6.37-rc5+ #1 SMP Fri Dec 10 12:09:02 EST 2010 x86_64 GNU/Linux
> $
>
> (even though it says lynx, it's maverick simply fully updated.)
>
>  and this is from lspci:
>
> 00:02.0 VGA compatible controller: Intel Corporation Core Processor
> Integrated Graphics Controller (rev 12) (prog-if 00 [VGA controller])
>        Subsystem: Acer Incorporated [ALI] Device 031c
>        Flags: bus master, fast devsel, latency 0, IRQ 41
>        Memory at d0000000 (64-bit, non-prefetchable) [size=4M]
>        Memory at c0000000 (64-bit, prefetchable) [size=256M]
>        I/O ports at 3050 [size=8]
>        Expansion ROM at <unassigned> [disabled]
>        Capabilities: <access denied>
>        Kernel driver in use: i915
>        Kernel modules: i915
> ... snip ..
>
>  i've tried various suggestions from google, as in "modeset noacpi"
> and others, but nothing works to get video on my rc7+ kernel.  the
> rc5+ verison, though, boots properly without incident.  and the link i
> gave to launchpad above suggests, at the bottom, that even as late as
> dec 12, people were still having problems.
>
>  i'm open to suggestions, not scared to patch my kernel source and
> rebuild and reboot.
>
> rday
>
> --
>
> ========================================================================
> Robert P. J. Day                               Waterloo, Ontario, CANADA
>                        http://crashcourse.ca
>
> Twitter:                                       http://twitter.com/rpjday
> LinkedIn:                               http://ca.linkedin.com/in/rpjday
> ========================================================================
>
> --
> kernel-team mailing list
> kernel-team@lists.ubuntu.com
> https://lists.ubuntu.com/mailman/listinfo/kernel-team
>

CC: lkml

did you tried 2.6.37-rc8-git1 ?
