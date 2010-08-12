Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636Ab0HLVOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:14:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38040 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760591Ab0HLVOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WfKeoYR028ku6tDR/wd1KLQqgTijVH0HpVrKKS9cpB6UgGBR38/ofwbtx81xbSBC7p
         6+Y01Q+cUew2kvTvVLMjthfQS0w5XafT9a8rTZmLqnbCB+7CC66ayff8EmWyaJvwT2am
         9PKsx+4jE0QCHx2TTHtmpeJRW7w82PsDdSJBo=
Subject: Re: 2.6.36: Sound stop working
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4C646110.1040104@gmail.com>
References: <201008122200.05598.thomas@m3y3r.de>
	 <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>
	 <s5hpqxntw64.wl%tiwai@suse.de>  <4C646110.1040104@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 00:14:36 +0300
Message-ID: <1281647676.2712.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 23:01 +0200, Jiri Slaby wrote: 
> On 08/12/2010 10:26 PM, Takashi Iwai wrote:
> > At Thu, 12 Aug 2010 23:10:15 +0300,
> > Pekka Enberg wrote:
> >>
> >> On Thu, Aug 12, 2010 at 11:00 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> >>> My sound card stop to work since a few commits. I tried to bisect it and ended up with this:
> >>>
> >>> There are only 'skip'ped commits left to test.
> >>> The first bad commit could be any of:
> >>> 3bcf3860a4ff9bbc522820b4b765e65e4deceb3e
> >>> c1e5c954020e123d30b4abf4038ce501861bcf9f
> >>> We cannot bisect more!
> >>>
> >>> any ideas what to do now?
> >>
> >> Takashi, maybe this is related to Linus' problem?
> > 
> > Yeah, I guess so, since I couldn't see any obvious problem in sound/*.
> > 
> > PulseAudio uses inotify in udev-detection module, at least.
> > It's possible that inotify change may hit the sound in the end.
> 
> Probably I got into this problem yesterday. Found out that PA fails to
> open /dev/snd/pcmC0D0p _second_ time. It opens it, then closes, then
> opens it again and gets EBUSY. aplay is OK.
I confirm that here.

> 
> (If this is the same issue.)
> 
It must be..


Best regards,
Maxim Levitsky

