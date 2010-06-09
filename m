Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab0FINXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 09:23:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60850 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab0FINXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 09:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=QkrvJ77d4Ubh65pZLz/vD3u1yT2ERe4MqXdN7bS89kX33wRPargp7iyf4D1xzqLlGx
         T5G/u6k9jUdJmhKM5nFaOoWMmhClleIxgA+UZfsFZht+Zo01a0ORjxd6ip2kRAP0ZP6U
         WKATvgjGn08qUgJQ9l4ZChk6Hmzz1WozBQyVU=
From: Eric Lacombe <goretux@gmail.com>
To: Zhenyu Wang <zhenyuw@linux.intel.com>, Len Brown <lenb@kernel.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: [BUG] ACPI/dynamic-hybrid-graphics (?) on Vaio VPCZ11 - screen does not light up on resume [was: Re: Intel Arrandale IGP - screen does not light up on resume]
Date: Wed, 9 Jun 2010 15:23:12 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-custom; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201005310142.40209.goretux@gmail.com> <201006050013.17653.goretux@gmail.com> <201006071431.33789.goretux@gmail.com>
In-Reply-To: <201006071431.33789.goretux@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006091523.13546.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now I've got a workaround:
adding these 2 lines to my resume script makes the laptop monitor light up:

xrandr --output DP3 --off
xrandr --output DP3 --auto

	Eric


Le lundi 7 juin 2010 14:31:33, Eric Lacombe a écrit :
> I find a way to light up the screen of my laptop after resume (but the
> solution is not really satisfactory) :
> When the resume step seems complete, I plug an auxiliary monitor through
> the VGA connector, and the laptop screen light up immediately.
> 
> Any idea on the source of this problem ? and how to resolve it ?
> 
> Thanks in advance for your response.
> 
> 	Eric
> 
> Le samedi 5 juin 2010 00:13:17 Eric Lacombe, vous avez écrit :
> > Hi, (the introduction is at the end of this one, it comes from a previous
> > mail sent to Zhenyu Wang)
> > 
> > I was thinking that it could come from bogus ACPI tables.
> > 
> > Someone said to me (from sony-vaio-z-series@lists.launchpad.net) that
> > with a patched BIOS (that someone does and that I don't really want to
> > test) that allows to access a more advanced menu from my laptop, it will
> > allows to have the switch button (that switches between nvidia chipset
> > and Intel IGP) behave statically and not dynamically as it does now.
> > And it seems that with its laptop he was able to resume correctly from
> > the nvidia chipset.
> > 
> > I added Dave Airlie, as I know he played with hybrid-graphics (by the way
> > switcheroo make crashed my laptop)
> > 
> > I could send to you my DSDT if it could give you some clues on what
> > screwed things up. Just ask to me.
> > 
> > If someone has any idea, I could do some tests, try some patchs ?
> > And as always feel free to ask me more information if you need.
> > 
> > Best regards,
> > 
> > 	Eric
> > 
> > Le lundi 31 mai 2010 01:42:39, Eric Lacombe a écrit :
> > > Hi,
> > > 
> > > I've got a problem with my laptop (powered by i7 Arrandale, it's a Sony
> > > Vaio Z11Z9E), when I resume from "suspend to ram" my screen does not
> > > light up. X uses the Intel IGP.
> > > Maybe it is an issue with the driver of the IGP of the Core i7
> > > Arrandale?
> > > 
> > > I currently use Linux 2.6.34, and have tested 2.6.33 and 2.6.32 (I see
> > > on google that there were some problems about Intel IGP and
> > > blackscreen. I was hit by them too at that time)
> > > 
> > > If you have any suggestions or if you want me to test any patch, I
> > > would be glad to do so.
> > > Feel free to ask me any information I could provide to you about this
> > > problem.
> > > 
> > > Best regards,
> > > 
> > > 	Eric
