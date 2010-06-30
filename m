Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0F3QLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:11:17 -0400
Received: from smtp-out-161.synserver.de ([212.40.180.161]:1064 "HELO
	smtp-out-161.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754118Ab0F3QLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:11:16 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 28118
Date: Wed, 30 Jun 2010 18:11:06 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm fixes + agp + one fb patch (bisected)
Message-ID: <20100630161106.GA1743@arch.tripp.de>
References: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
 <20100630065440.GA1736@arch.tripp.de>
 <20100630073145.GA1722@arch.tripp.de>
 <AANLkTimr33Bar73xO9IjDWhPWidZr0HB663oRU8fDCyt@mail.gmail.com>
 <20100630145859.GC1722@arch.tripp.de>
 <AANLkTil58kym4SgjMDv8RCXWkoUHKVYfTpT775uufoDJ@mail.gmail.com>
 <20100630151449.GA1748@arch.tripp.de>
 <AANLkTikHDUSpYrx4yCLFPNuTw4FFyLcf2kvJ2gVWicZA@mail.gmail.com>
 <20100630155007.GA1696@arch.tripp.de>
 <AANLkTilHe-eWT02LnFqr4C83d123aEtnRA18S1jxwIJC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilHe-eWT02LnFqr4C83d123aEtnRA18S1jxwIJC@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 12:04:35PM -0400, Alex Deucher wrote:
> On Wed, Jun 30, 2010 at 11:50 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On Wed, Jun 30, 2010 at 11:34:53AM -0400, Alex Deucher wrote:
> >>
> >> The attached patch should fix the issue.
> >
> > Sorry, but it does not. I've still the same issue with your patch
> > applied.
> 
> New patch attached.  The rs690_pm_info function wasn't getting called
> at all on rs780/rs880 and it needs to be.

Looks good. Thanks Alex.

-- 
Markus
