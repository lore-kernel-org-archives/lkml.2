Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0HWMec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:34:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41256 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0HWMe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oE2jLPpt4s+wL7gsoQUy7v2/rx0vW9RNodEdtTKNcdKxOEXC6vRzbJYhKn2mVnPQEf
         TBPu+Nh0Q/3wF9SWElHZB7awJFu93fHXDCqUk70EZg16+S+bbXEEGOfAe2c+dggva4Wt
         IxQ8hD/KM+9nUvrZX33GyP682xjpnrW07odKQ=
Subject: Re: [BISECTED][2.6.35 regression] iptables busted on Mac G5
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20100823121644.GH1727@Chamillionaire.breakpoint.cc>
References: <19546.53659.970308.750410@pilspetsen.it.uu.se>
	 <19570.25954.196694.563887@pilspetsen.it.uu.se>
	 <20100823121644.GH1727@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 14:34:22 +0200
Message-ID: <1282566862.2486.29.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 23 août 2010 à 14:16 +0200, Florian Westphal a écrit :
> Mikael Pettersson <mikpe@it.uu.se> wrote:
> >  > I'll try to narrow it down further next week when I'm at the
> >  > machine's location again.  Meanwhile I would be grateful if
> >  > anyone has any ideas about what the issue might be.  I'll add
> >  > that a Mac G4 (ppc32) with similar kernel configuration and
> >  > user-space works fine with 2.6.35 and iptables.
> > 
> > The bug is still present in 2.6.36-rc2.
> 
> sigh.
> Do you run 64 bit kernel with 32bit userland?
> If so, yes, thats broken since 2.6.35. I submitted a fix
> (http://marc.info/?l=netfilter-devel&m=128116762801769&w=2),
> but it was not yet applied.
> 
> Will resend it later today.

CC netdev

Please send this patch to netdev@vger.kernel.org and David S. Miller,
because it seems Patrick is on vacation or something.

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks


