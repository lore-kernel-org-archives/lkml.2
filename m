Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0HWMQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:16:48 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34710 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976Ab0HWMQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:16:45 -0400
Date: Mon, 23 Aug 2010 14:16:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [BISECTED][2.6.35 regression] iptables busted on Mac G5
Message-ID: <20100823121644.GH1727@Chamillionaire.breakpoint.cc>
References: <19546.53659.970308.750410@pilspetsen.it.uu.se>
 <19570.25954.196694.563887@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19570.25954.196694.563887@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> wrote:
>  > I'll try to narrow it down further next week when I'm at the
>  > machine's location again.  Meanwhile I would be grateful if
>  > anyone has any ideas about what the issue might be.  I'll add
>  > that a Mac G4 (ppc32) with similar kernel configuration and
>  > user-space works fine with 2.6.35 and iptables.
> 
> The bug is still present in 2.6.36-rc2.

sigh.
Do you run 64 bit kernel with 32bit userland?
If so, yes, thats broken since 2.6.35. I submitted a fix
(http://marc.info/?l=netfilter-devel&m=128116762801769&w=2),
but it was not yet applied.

Will resend it later today.
