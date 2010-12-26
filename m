Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab0LZHg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 02:36:28 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48127 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab0LZHg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 02:36:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=tiH4BvtMzKUxEMtmtWGcyMO/u3s4LM4XVH6ZqhrLb3FL6Fx/sZ7Jie1NDGjxLhFS6l
         hjtkr9/WLNPpE0ejqtMcuUCbRqGO44r7Nw7mX4Q51KsbmBQlxvEpipoc5YxUtIWIwMlg
         j2behW6D4SJNGtkKhhQD+E5yYM03uuAktrDdU=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: recurring problem, booting to black screen with intel GPU
Date: Sun, 26 Dec 2010 08:36:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6; KDE/4.4.5; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.DEB.2.00.1012251737030.4626@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.00.1012251737030.4626@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012260836.22827.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See:
https://bugzilla.kernel.org/show_bug.cgi?id=25242

Regards

On sobota, 25 grudnia 2010 o 23:42:59 Robert P. J. Day wrote:
>   on my ubuntu laptop (gateway NV79), a 2.6.37-rc7+ kernel i just
> built now boots to a black screen.  no text mode, no virtual consoles,
> nothing.
> 
>   this is probably the best explanation:
> 
> http://www.oblurb.com/ubuntu-dell-latitude-e6510-intel-gpu-blank-screen.htm
> l
> 
> annoyingly, i'm currently running a 2.6.37-rc5+ hand-rolled kernel
> that works fine, but this more recent kernel doesn't, and a kernel
> *earlier* also doesn't work, so this issue seems to come and go.
> 
>   here's another extended conversation on the same topic:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/600453
> 
> here's the relevant output from lspci:
> 
> 00:02.0 VGA compatible controller: Intel Corporation Core Processor
> Integrated Graphics Controller (rev 12) (prog-if 00 [VGA controller])
>         Subsystem: Acer Incorporated [ALI] Device 031c
>         Flags: bus master, fast devsel, latency 0, IRQ 41
>         Memory at d0000000 (64-bit, non-prefetchable) [size=4M]
>         Memory at c0000000 (64-bit, prefetchable) [size=256M]
>         I/O ports at 3050 [size=8]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: <access denied>
>         Kernel driver in use: i915
>         Kernel modules: i915
> 
> if i use "nomodeset", i can boot to the command line and no further.
> i'm open to suggestions.
> 
> rday

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
