Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0E1FHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:07:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48328 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab0E1FHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ss7s64kFIq8abmd9zMzui58d9nBuJlTTpRTIOO22cfqvrskWL1YC2ih2tM3auJxJs1
         LGbQ6q8PJfIqj3zZ0Mv+sJhMc2WKt3hwzEeTh0X/KUdpqRdpH1eE3UvAv9oQKOMMcr+2
         4+H2GqrrnHyz/fT/fozGX4g9XlHToLkSNYttk=
Date: Thu, 27 May 2010 22:07:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Florian Ragwitz <rafl@debian.org>,
       Arjan Opmeer <arjan@opmeer.net>, Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.35-rc0
Message-ID: <20100528050716.GB2663@core.coreip.homeip.net>
References: <20100520165243.GA20861@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005271837050.11382@i5.linux-foundation.org>
 <AANLkTiklv48cDWNqKlFfh5RVtxxNH8shH_JjDypPgeHA@mail.gmail.com>
 <alpine.LFD.2.00.1005272108210.11382@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005272108210.11382@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 09:12:27PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 28 May 2010, Dave Airlie wrote:
> > 
> > Was this in GNOME?
> > 
> > Does System->Preferences->Mouse have a touchpad tab? do it have tapping off?
> 
> Bingo! Yup, that turns a totally useless piece-of-crap touchpad into a 
> perfectly cromulent one!
> 
> Too bad that the default behavior made it act so horribly bad. 
> 

So I take it we can leave the touchpad in Enaltech mode for now?

-- 
Dmitry
