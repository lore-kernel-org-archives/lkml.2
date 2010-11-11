Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab0KKICj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:02:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50814 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab0KKICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:02:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=NZp9x19GE/ny3+S88g0eE1PiZBlblvKKKdYW3EWFj9ZTYaAQVPPetQqLT+VHYvXPiz
         x0qAlIAi/KFBQyfSrxOqLuvLx+5NwF5oby5FXB8JLO7r/amhkYXKzu3Q6QidysDW85zQ
         nNg1rY07yeXRrDmkBzd8+dDQ1fw89G3UE1w94=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: PROBLEM: i915 modesetting - weird offset graphics (v2.6.37-rc1-27-gff8b16d)
Date: Thu, 11 Nov 2010 09:02:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        chris@chris-wilson.co.uk, intel-gfx@lists.freedesktop.org
References: <1288855558.3916.293.camel@constitution.bos.jonmasters.org>
In-Reply-To: <1288855558.3916.293.camel@constitution.bos.jonmasters.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011110902.32267.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 4 listopada 2010 o 08:25:58 Jon Masters wrote:
> Folks,
> 
> I upgraded the userspace on my EeePC 1015PEM netbook to the latest
> Fedora (F15) rawhide and booted a custom kernel in order to test both
> the RC1 and also see if the now in-staging brcm80211 behaves better (it
> doesn't, it still can't survive suspend at all, separate issue though).
> 
> The xrandr output is identical in both case, showing a mode of 1024x600
> being the one that X is currently using. Booting with i915 modesetting
> disabled does avoid the weird offset but of course X doesn't start. I
> can bisect this if there isn't already some suggestions from the
> audience, in particular is to what debug information you need.
> 
> Kernel: v2.6.37-rc1-27-gff8b16d
> 
> Photos:
> 	http://www.flickr.com/photos/jonmasters/5145351220/
> 	http://www.flickr.com/photos/jonmasters/5144748543/
> 
> Said system will likely be at plumbers in the am...
> 
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=22712
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
