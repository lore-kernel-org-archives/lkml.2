Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab0CTToc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:44:32 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:42317 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0CTToa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r67TZtV6GhV5gPxlBeol7BMyTXnFDdnMtRR2um4kCV9n/bgwiaC+qfgdBsjp7VEnXR
         7G77Zy4QdRUaOvFFVW1oH1dV1WxkqZZ52rDQ3uAVbBQtzG6lzWa04thTUN+h2ArOPMm7
         gGlv2sjb2RgOGn4GWgMh2NPPbUpQIIUPtfUk8=
Date: Sat, 20 Mar 2010 12:44:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@enmesh.se>
Cc: linux-input <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: input: mt: Software finger tracking in the kernel?
Message-ID: <20100320194424.GC28402@core.coreip.homeip.net>
References: <4BA358DB.20708@enmesh.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA358DB.20708@enmesh.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Fri, Mar 19, 2010 at 11:58:35AM +0100, Henrik Rydberg wrote:
> Hi Dmitry,
> 
> there is an ongoing discussion about adding multitouch to X
> (http://lists.x.org/archives/xorg-devel/2010-March/006206.html), which is
> beginning to take on more solid form.
> 
> One of the suggestions emerging from that discussion is to add the software
> finger tracking to the kernel. Back in summer 2009 when I thought about this, I
> disregarded it as being too experimental. I have since then reconsidered,
> starting to think it really is the right place.
> 
> The MT protocol allows applications to take advantage of multi-contact hardware,
> but leaves the problems of finger tracking and filtering to the user. Arguably,
> no application can make good use of MT without these, so the problem is pushed
> forward, in this case to evdev or equivalent.
> 
> The knowledge of signal-to-noise ratios and prior input states resides in the
> kernel. Because of this, the finger matching and filtering would naturally
> reside within the kernel.
> 
> So, if there were to appear patches to include matching in the input core, would
> you consider them? :-)
> 

I am not sure if input core itself is the proper place to do such
thing, I'd envisioned something more like a library providing common
code that drivers could opt in to use, like we hane ff-memless for
memory-less force-feedback devices.

Does it make any sense? I guess post the skeleton of the code and we can
discuss further.

-- 
Dmitry
