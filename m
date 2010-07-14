Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0GNNaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:30:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38797 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0GNNaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:30:18 -0400
Date: Wed, 14 Jul 2010 09:15:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Christoph Egger <siccegge@cs.fau.de>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de,
        Luis Correia <luis.f.correia@gmail.com>
Subject: Re: [PATCH 01/11] Removing dead RT2800PCI_SOC
Message-ID: <20100714131527.GB2352@tuxdriver.com>
References: <cover.1279110894.git.siccegge@cs.fau.de>
 <29013fb6eab9e95e95d61df894797d2455dfa10c.1279110894.git.siccegge@cs.fau.de>
 <AANLkTinO32CIe0HBTXjP_bcAz0nMEw6wvcZwcob1fX3r@mail.gmail.com>
 <AANLkTikCeDys9e1EnE9GdiJtDRcbqW3gzvsmjzvB_yDs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikCeDys9e1EnE9GdiJtDRcbqW3gzvsmjzvB_yDs@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 02:52:14PM +0200, Ivo Van Doorn wrote:
> On Wed, Jul 14, 2010 at 2:46 PM, Luis Correia <luis.f.correia@gmail.com> wrote:
> > On Wed, Jul 14, 2010 at 13:39, Christoph Egger <siccegge@cs.fau.de> wrote:
> >> While RT2800PCI_SOC exists in Kconfig, it depends on either
> >> RALINK_RT288X or RALINK_RT305X which are both not available in Kconfig
> >> so all Code depending on that can't ever be selected and, if there's
> >> no plan to add these options, should be cleaned up
> >>
> >> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> >
> > NAK,
> >
> > this is not dead code, it is needed for the Ralink System-on-Chip
> > Platform devices.
> >
> > While I can't fix Kconfig errors and the current KConfig file may be
> > wrong, this code cannot and will not be deleted.
> 
> When the config option was introduced, the config options RALINK_RT288X and
> RALINK_RT305X were supposed to be merged as well soon after by somebody (Felix?)
> 
> But since testing is done on SoC boards by Helmut and Felix, I assume the code
> isn't dead but actually in use.

Perhaps Helmut and Felix can send us the missing code?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
