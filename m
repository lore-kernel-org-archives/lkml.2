Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1ALTHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 14:07:54 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51420 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1ALTHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:07:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=dzBgVtJUURBl4OLefW7Pq8j25DyaeClRD3NK7gJ7bKYrkv5Ei2VspGHCPkMymIznlD
         aOPck3tSUVfinysHnigU4xi+/sRks4MClzszdI/BcyR7p48lhKSN2p2UNLi5NkWux1z6
         mPF7b6sxDggCnABUNp3n2dEFKlGUSZWukjENc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: trentbuck@gmail.com
Subject: Re: BUG: blank screen i915 (N10) LVDS in 2.6.37
Date: Wed, 12 Jan 2011 20:07:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110107085931.GA1400@dali>
In-Reply-To: <20110107085931.GA1400@dali>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101122007.46480.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=26602
for your bug report, please add your address to the CC list in there, thanks!

On piątek, 7 stycznia 2011 o 09:59:37 trentbuck@gmail.com wrote:
> When I boot 2.6.37, the onboard head remains blank.
> It works in 2.6.36.  In both cases, the VGA head works fine.
> 
> I had problems with 2.6.37rc*; I can't remember if they were related,
> but I know .36 works for me.  The screen blanks immediately after
> extlinux loads the kernel; I have i915 compiled in.
> 
> I am using Debian Sid with xserver-xorg-video-intel 2:2.13.0-5.
> 
> video=LVDS1:e does not help, nor does video=LVDS-1:e.  With .32 (and
> .36, I think), xrandr reports LVDS-1 with the hyphen, but in .37 it
> reports it without the hyphen.  Likewise for VGA1 VGA-1.  I have not
> tried nomodeset.
> 
> My default environment is fbcon.  I tried to start X on .37 by typing
> blind into fbcon, and nothing came up.  From this, I presume that X
> also can't address the LVDS head properly.  I didn't try it with a VGA
> head attached.
> 
> The unit in question is an Asus Eee PC 1005P netbook.
> 
> IIRC I also changed from eeepc_laptop on .36 to eeepc_wmi .37 (with
> the associated change to the boot parameter in .config); dunno if that
> matters.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
