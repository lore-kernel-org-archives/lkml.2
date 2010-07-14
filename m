Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab0GNPOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:14:17 -0400
Received: from nbd.name ([88.198.39.176]:36941 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab0GNPOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:14:16 -0400
X-Greylist: delayed 1759 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2010 11:14:15 EDT
Message-ID: <4C3DCD5C.1080705@openwrt.org>
Date: Wed, 14 Jul 2010 16:44:44 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Ivo Van Doorn <ivdoorn@gmail.com>, Christoph Egger <siccegge@cs.fau.de>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de,
        Luis Correia <luis.f.correia@gmail.com>
Subject: Re: [PATCH 01/11] Removing dead RT2800PCI_SOC
References: <cover.1279110894.git.siccegge@cs.fau.de> <29013fb6eab9e95e95d61df894797d2455dfa10c.1279110894.git.siccegge@cs.fau.de> <AANLkTinO32CIe0HBTXjP_bcAz0nMEw6wvcZwcob1fX3r@mail.gmail.com> <AANLkTikCeDys9e1EnE9GdiJtDRcbqW3gzvsmjzvB_yDs@mail.gmail.com> <20100714131527.GB2352@tuxdriver.com>
In-Reply-To: <20100714131527.GB2352@tuxdriver.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-14 3:15 PM, John W. Linville wrote:
> On Wed, Jul 14, 2010 at 02:52:14PM +0200, Ivo Van Doorn wrote:
>> On Wed, Jul 14, 2010 at 2:46 PM, Luis Correia <luis.f.correia@gmail.com> wrote:
>> > On Wed, Jul 14, 2010 at 13:39, Christoph Egger <siccegge@cs.fau.de> wrote:
>> >> While RT2800PCI_SOC exists in Kconfig, it depends on either
>> >> RALINK_RT288X or RALINK_RT305X which are both not available in Kconfig
>> >> so all Code depending on that can't ever be selected and, if there's
>> >> no plan to add these options, should be cleaned up
>> >>
>> >> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
>> >
>> > NAK,
>> >
>> > this is not dead code, it is needed for the Ralink System-on-Chip
>> > Platform devices.
>> >
>> > While I can't fix Kconfig errors and the current KConfig file may be
>> > wrong, this code cannot and will not be deleted.
>> 
>> When the config option was introduced, the config options RALINK_RT288X and
>> RALINK_RT305X were supposed to be merged as well soon after by somebody (Felix?)
>> 
>> But since testing is done on SoC boards by Helmut and Felix, I assume the code
>> isn't dead but actually in use.
> 
> Perhaps Helmut and Felix can send us the missing code?
The missing code is a MIPS platform port, which is currently being
maintained in OpenWrt, but is not ready for upstream submission yet.
I'm not working on this code at the moment, but I think it will be
submitted once it's ready.

- Felix
