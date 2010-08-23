Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0HWNO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:14:26 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:45588 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab0HWNOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:14:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19570.29741.746144.453539@pilspetsen.it.uu.se>
Date: Mon, 23 Aug 2010 15:14:21 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Florian Westphal <fw@strlen.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [BISECTED][2.6.35 regression] iptables busted on Mac G5
In-Reply-To: <20100823121644.GH1727@Chamillionaire.breakpoint.cc>
References: <19546.53659.970308.750410@pilspetsen.it.uu.se>
	<19570.25954.196694.563887@pilspetsen.it.uu.se>
	<20100823121644.GH1727@Chamillionaire.breakpoint.cc>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Westphal writes:
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

Yes.

 > If so, yes, thats broken since 2.6.35. I submitted a fix
 > (http://marc.info/?l=netfilter-devel&m=128116762801769&w=2),
 > but it was not yet applied.
 > 
 > Will resend it later today.

That patch applied to 2.6.35 fixed the problem on my G5.  Thanks!

Tested-by: Mikael Pettersson <mikpe@it.uu.se>

/Mikael
