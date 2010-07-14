Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0GNOPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:15:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65438 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0GNOPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:15:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=i8WeJXtiBzEjXgxlblqiCI630fjnAmY12Y3TG+7CIEhY7yRQ8khLUqjgMJBjnHNfj8
         Gv5AUPSNTbTezsgwvOox1bYZGbYFc5k8q1qEamn44FIcrtuw9Ascav4O07/gj5AQ5Bk8
         /CcSDSw09LBWCIeTd/yVZp8seE3UFxJ9hg7UI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 01/11] Removing dead RT2800PCI_SOC
Date: Wed, 14 Jul 2010 16:14:55 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Egger <siccegge@cs.fau.de>, Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de,
        Luis Correia <luis.f.correia@gmail.com>
References: <cover.1279110894.git.siccegge@cs.fau.de> <AANLkTinO32CIe0HBTXjP_bcAz0nMEw6wvcZwcob1fX3r@mail.gmail.com> <AANLkTikCeDys9e1EnE9GdiJtDRcbqW3gzvsmjzvB_yDs@mail.gmail.com>
In-Reply-To: <AANLkTikCeDys9e1EnE9GdiJtDRcbqW3gzvsmjzvB_yDs@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201007141614.55756.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 14 July 2010 02:52:14 pm Ivo Van Doorn wrote:
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
> 
> Ivo

I fully agree with Luis and Ivo that the proposed patch is invalid and
shouldn't be applied (the "code cannot and will not be deleted" anyway)..

[ Under "The New Normal" rules the code doesn't even have to work to be
  merged and/or stay in the kernel so 9 months of code not being used by
  any real user doesn't matter a tiny bit.. ]

--
Bartlomiej Zolnierkiewicz
