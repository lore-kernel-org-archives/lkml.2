Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1BNTV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:21:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51737 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab1BNTV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:21:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=pHkEMbHp+Pp7qHXUDXcq6Kf8oCS/7WCtKd2kEHURWQiWaLmhgNr0JnwWul0fAkumdS
         2P+hZfwUuJvudXKggEN4tACfBjogH+PU0TOV3wrKTS/Tu9ZkeFc7cHX9KOFstZS30Czg
         D8mw1Rl1BnozL4h4dxLOF29q/C3tVQF+DX3iE=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: System lockup with 2.6.38-rc4+
Date: Mon, 14 Feb 2011 19:21:14 +0000
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
References: <201102141731.29331.chris2553@googlemail.com> <87fwrqxzcw.fsf@gmail.com>
In-Reply-To: <87fwrqxzcw.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102141921.14406.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 February 2011, Ben Gamari wrote:
> On Mon, 14 Feb 2011 17:31:29 +0000, Chris Clayton <chris2553@googlemail.com> 
wrote:
> > Hi,
> >
> > I'm not subscribed, so please cc me on any reply.
> >
> > I've just had a complete system lock up with a kernel that I pulled,
> > built and installed yesterday morning. IT was locked hard and I had to
> > power off and on to get it back.
>
> It looks like the GPU barfed. If you SSH'd in to the machine you'd find
> that everything but the display and resources held by the hung X server
> would be fine. Were you doing anything particular in your X session when
> this happened? There's a good chance this isn't actually a kernel bug
> but instead is a DRI client doing something dumb.
>

I was panning around a google map in firefox. Other than that, I had no other 
applications running. I've just done the same thing in 2.6.37 for 10 minutes 
with no problems - 2.6.38-rc4+  In fact, I don't recall having this sort of 
problem in any previous kernel.

> Cheers,
>
> - Ben
>
> P.S. The bzipped kernel image generally won't help in diagnosing the
> problem. The most important thing to include in a bug report is the
> kernel version and the dmesg output from the failure if available. Folks
> will ask later if more is necessary.

Note kernel and Xorg logs, plural - i.e. the logs from the /var/log/kernel 
and /var/Xorg.log. The kernel version is in the subject.

Thanks,

Chris

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
