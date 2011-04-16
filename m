Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab1DPEEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 00:04:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48016 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1DPEEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 00:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=CWd04YMzzV7rr+94wT4XIwITGztutTGLpIYAS9Yqvwi3ice075BqhTx+rRCVOnmQMZ
         zA9ui475LiLeC3GsXTeF3Jr1XASgsG4D/zhNps2l0HfJXLgM+qayOd4dxiEBEOQ9v4eX
         diUcXFQYcHjQPW6jIA6ROWATP+ToV0x+a3Tus=
From: Marek Vasut <marek.vasut@gmail.com>
To: Cyril Hrubis <metan@ucw.cz>
Subject: Re: Zaurus CF tests -- ok
Date: Sat, 16 Apr 2011 06:04:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-1-amd64; KDE/4.6.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
References: <20110415211822.GB21111@atrey.karlin.mff.cuni.cz> <20110415213817.GC4420@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20110415213817.GC4420@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104160604.42482.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 15, 2011 11:38:17 PM Cyril Hrubis wrote:
> Hi!
> 
> > After getting _good_ power supply, I was able to untar and rm ltp tree
> > 100 times so far. 2.6.38, ext3. (So metan no, I do not see any weird
> > ext3 problems).
> 
> Hmm, I'm using original adapter, but who knows if it's okay to use...

I can lend you Eric's, but promise you won't break it or do anything weird to it 
;-)
> 
> > Another strange thing is... I see lots of duplicated keystrokes --
> > like type "pavel" but machine understands "paavel". But it only seems
> > to happen when I'm _not_ trying to debug it?!
> 
> That seems to be side effect of machine under load (it has gpio keyboard).

Yea ... it's that polled para-keyboard I guess.
> 
> > (
> > So... just because something needs 5V does not mean you should charge
> > it from USB.
> > 
> > Yes, I'm talking about zaurus. I noticed that it crashed rather
> > quickly when connected to USB power. (For example in tar/rm test).
> > So I took multimeter, and there was 4.15..4.5V on USB :-(.
> > 
> > With power from USB extension cable, it crashes in <5 minutes. It
> > seems to toggle charger a lot, as voltage on the cable is only
> > 4.2..4.5V. I guess it is software problem in the charging code.
> > )
> 
> The zaurus actually is AFAIK unable to run from battery when connected to
> the external power, so weak power line may explain some of the strange
> behaviour.

As for the charging code, do we even have anything even remotely resembling that 
?
