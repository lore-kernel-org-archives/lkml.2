Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482Ab1ETAnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:43:42 -0400
Received: from ozlabs.org ([203.10.76.45]:45090 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618Ab1ETAnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:43:41 -0400
From: Michael Neuling <mikey@neuling.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Subject: Re: [PATCH 3/7] [RFC] add support for BlueGene/P FPU
In-reply-to: <BANLkTindzEFRjEGkc9bLccrFUdVtvbA73A@mail.gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com> <1305753895-24845-3-git-send-email-ericvh@gmail.com> <425.1305784718@neuling.org> <BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com> <29601.1305840992@neuling.org> <BANLkTi=rc5vZm3xAXHpHSxSH1wBWKhv92A@mail.gmail.com> <6241.1305847001@neuling.org> <BANLkTindzEFRjEGkc9bLccrFUdVtvbA73A@mail.gmail.com>
Comments: In-reply-to Eric Van Hensbergen <ericvh@gmail.com>
   message dated "Thu, 19 May 2011 19:30:20 -0500."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Fri, 20 May 2011 10:43:40 +1000
Message-ID: <17455.1305852220@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >> > Eric,
> >> >> >
> >> >> >> This patch adds save/restore register support for the BlueGene/P
> >> >> >> double hummer FPU.
> >> >> >
> >> >> > What does this mean? =3DA0Needs more details here.
> >> >> >
> >>
> >> okay, I've changed it a bit in [V2], if you want more I can do my best.
> >
> > If you can describe the whole primary and secondary registers that'd be
> > cool. =A0ASCII art would be awesome! :-)
> >
> 
> You sure you don't just want a bitfield.conf? :)  

hehe, maybe an interpretive dance video posted on youtube?

> I'll do my best, but my ASCII art isn't what it used to be.  I'll also
> include a reference to the PDF.

Something self contained in the comments would be great as external
links tend to disappear.  

> >> > Ok, sounds like there is 32*8*2 bytes of data, rather than the normal
> >> > 32*8 bytes for FP only (ignoring VSX). If this is the case, then you'll
> >> > need make 'fpr' in the thread struct bigger which you can do by setting
> >> > TS_FPRWIDTH = 2 like we do for VSX.
> >> >
> 
> Okay - so basically what I have now and TS_FPRWIDTH=2 ?

Yes.

> >>
> >> Since it isn't available on other chips, shoudl it just be PPC_BGP_FPU
> >> or PPC_BGP_DOUBLE_FPU?
> >
> > I'd probably still prefer it disassociated with the CPU name, but we are
> > really bike shedding here. =A0I'm not too fussed.
> >
> 
> I'll leave it separate and switch it to PPC_FP2 (or would you prefer
> PPC_FP2_FPU to make it clear) since the public PDF refers to it this
> way.

PPC_FPU_FP2 would be my vote.

> If that all sounds good, I'll spin [V3] tomorrow.

Thanks!

Mikey
