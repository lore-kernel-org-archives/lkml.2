Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1CYBHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 21:07:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39680 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356Ab1CYBHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 21:07:08 -0400
X-Sasl-enc: xxEw/3Mf34bliONpr0IGsDRtroF4O4PikeysoOzJgM7o 1301015227
Date: Thu, 24 Mar 2011 22:07:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] APM: delete APM in Linux-2.6.40
Message-ID: <20110325010705.GB4535@khazad-dum.debian.net>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <20110324102116.GA17446@khazad-dum.debian.net>
 <alpine.LFD.2.02.1103241903030.16085@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103241903030.16085@x980>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Len Brown wrote:
> > People with a ThinkPad T23, T30 will really not appreciate this, and it
> > should not be too difficult to recruit some as testers.
> 
> I have both, and they both support ACPI.

I wonder why I had some users of those two boxes advocating APM, maybe
it used to work better or something.  Or I got the T21 and A30 confused
with the T23.

Well, I don't think we need to support the thre-digit series ThinkPads,
the number of those still working is probably on the four digits
world-wide.  And I haven't heard from anyone with a T21 or A31 in a
while, so they might be down to five digits already.

If the T23 can actually work well in ACPI mode, I retract my objection.

> Re: lasting for years.
> Actually, I used to have several of both, but they're dying off,
> and they are excruciatingly slow...

Depends on what you use them for, I suppose.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
