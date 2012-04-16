Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2DPXYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:24:55 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:15286 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950Ab2DPXYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:24:54 -0400
Date: Mon, 16 Apr 2012 23:02:49 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Russell Whitaker <russ@ashlandhome.net>, linux-kernel@vger.kernel.org
Subject: Re: default framebuffer
Message-ID: <20120416220249.GA25109@milliways>
References: <alpine.LNX.2.00.1204152129060.2200@bigred.russwhit.org>
 <20120416140443.GA1153@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120416140443.GA1153@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wom5GMh1gUkA:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=FP58Ms26AAAA:8 a=Yrc_H3D_O720Q7uo5jYA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:04:43AM -0400, Nick Bowler wrote:
> Hi Russell,
> 
> On 2012-04-15 21:37 -0700, Russell Whitaker wrote:
> > 
> > What should I do to keep the screen at 80x25?
> 
> Load a bigger console font.  For example, the Terminus font package
> http://terminus-font.sourceforge.net/ includes some nice console fonts
> in a variety of sizes.  Try
> 
>   setfont ter-132b
> 
> to start.  Your distribution probably provides a convenient way to set
> the console font at boot.
> 
> Hope that helps,

 Alternatively, add video=something to the commandline in your
bootloader.  I've got a 1600x1200 screen.  On some machines I use my
12x22 font, on the others I use my 8x16 font with video=1024x768 ¹
Oh, and on my netbook I use the 12x22 for something like 95x30.  But
I also guess that exactly 80x25 is not necessarily critical,
provided the characters are legible.

 I've no idea which video= values work, and I'm using a lot more
than 80x25, but perhaps video=800x600 or video=640x480 (assuming, of
course, that you have a 4:3 screen and not the now-common 16:10)
with a small font will be in the right area.

¹ LatGrkCyr - they are in kbd as of 1.15.3, but there's no telling
whether you will like it - people using a light background almost
certainly will hate it.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
