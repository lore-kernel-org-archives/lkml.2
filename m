Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab0GOImo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:42:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55495 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab0GOIml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=HosM4/ntjYws7vgNzHEAeBAGP7R1gw1BkJe9hvYPL2Ywfj4P8h+aJ5xZ/xtjDty8vx
         nd6Qh4IVPhs47GZAZSAiKcaEmpMciLOnPNh/6mP07QOv5lAOKXe70ot95fAiZjBHnEdL
         eNyQU9iZE+g8aOgc3Lg+iUGR4KZAFSCCsxFeI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 01/11] Removing dead RT2800PCI_SOC
Date: Thu, 15 Jul 2010 10:41:55 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Ivo Van Doorn <ivdoorn@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de,
        Luis Correia <luis.f.correia@gmail.com>
References: <cover.1279110894.git.siccegge@cs.fau.de> <20100714131527.GB2352@tuxdriver.com> <4C3DCD5C.1080705@openwrt.org>
In-Reply-To: <4C3DCD5C.1080705@openwrt.org>
MIME-Version: 1.0
Message-Id: <201007151041.55112.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 July 2010 04:44:44 pm Felix Fietkau wrote:
> On 2010-07-14 3:15 PM, John W. Linville wrote:
> > On Wed, Jul 14, 2010 at 02:52:14PM +0200, Ivo Van Doorn wrote:
> >> On Wed, Jul 14, 2010 at 2:46 PM, Luis Correia <luis.f.correia@gmail.com> wrote:
> >> > On Wed, Jul 14, 2010 at 13:39, Christoph Egger <siccegge@cs.fau.de> wrote:
> >> >> While RT2800PCI_SOC exists in Kconfig, it depends on either
> >> >> RALINK_RT288X or RALINK_RT305X which are both not available in Kconfig
> >> >> so all Code depending on that can't ever be selected and, if there's
> >> >> no plan to add these options, should be cleaned up
> >> >>
> >> >> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> >> >
> >> > NAK,
> >> >
> >> > this is not dead code, it is needed for the Ralink System-on-Chip
> >> > Platform devices.
> >> >
> >> > While I can't fix Kconfig errors and the current KConfig file may be
> >> > wrong, this code cannot and will not be deleted.
> >> 
> >> When the config option was introduced, the config options RALINK_RT288X and
> >> RALINK_RT305X were supposed to be merged as well soon after by somebody (Felix?)
> >> 
> >> But since testing is done on SoC boards by Helmut and Felix, I assume the code
> >> isn't dead but actually in use.
> > 
> > Perhaps Helmut and Felix can send us the missing code?
> The missing code is a MIPS platform port, which is currently being
> maintained in OpenWrt, but is not ready for upstream submission yet.
> I'm not working on this code at the moment, but I think it will be
> submitted once it's ready.

People are using automatic scripts to catch unused config options nowadays
so the issue is quite likely to come back again sooner or later..

Would it be possible to improve situation somehow till the missing parts
get merged?  Maybe by adding a tiny comment documenting RT2800PCI_SOC
situation to Kconfig (if the config option itself really cannot be removed)
until all code is ready etc.?

I bet that Christoph would be willing to update his patch if you ask him
nicely..

Thanks,
--
Bartlomiej Zolnierkiewicz
