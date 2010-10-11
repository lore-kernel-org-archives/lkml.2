Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0JKXxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 19:53:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39183 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0JKXxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 19:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ef/LEden5baLA/W3QhjgtFDu2I75C2nzzneIoWXcxQlNjP5pkmhjd/L9OKRs5PJDpX
         i0HXMMaankj6kstaLS6nxojIsWbtCIY9fGWbsw5zBlYr40S/vxZZFo6Q21PtBvxBRoC/
         rsqbqEU6GdvK/R7H/Y/Jkzl9ufQMjhfLPbTVg=
MIME-Version: 1.0
In-Reply-To: <1286743352.11039.165.camel@Joe-Laptop>
References: <1286743352.11039.165.camel@Joe-Laptop>
Date: Mon, 11 Oct 2010 16:52:59 -0700
X-Google-Sender-Auth: 0geB8rXiSQjsV7FyGwBvUriZVYw
Message-ID: <AANLkTikVKufQRuMGd=cdig7ff4k2aw9Q1FWwMz3pgon-@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] drivers/net Documentation/networking: Create
 directory intel_wired_lan
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        e1000-devel <e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 13:42, Joe Perches <joe@perches.com> wrote:
> Perhaps it's better to move drivers from the very populated
> drivers/net directory into vendor specific directories similar
> to the Atheros approach used for drivers/net/wireless/ath/
>
> Move intel drivers and Documentation to separate directories
> Create drivers/net/intel_wired_lan/Kconfig.<speed> and Makefile
> Modify drivers/net/Kconfig and Makefile
> Update MAINTAINERS
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  .../networking/{ => intel_wired_lan}/e100.txt      |    0
>  .../networking/{ => intel_wired_lan}/e1000.txt     |    0
>  .../networking/{ => intel_wired_lan}/igb.txt       |    0
>  .../networking/{ => intel_wired_lan}/igbvf.txt     |    0
>  .../networking/{ => intel_wired_lan}/ixgb.txt      |    0
>  .../networking/{ => intel_wired_lan}/ixgbe.txt     |    0
>  .../networking/{ => intel_wired_lan}/ixgbevf.txt   |    0
>  MAINTAINERS                                        |   18 +--
>  drivers/net/Kconfig                                |  214 +-------------------
>  drivers/net/Makefile                               |    8 -
>  drivers/net/intel_wired_lan/Kconfig.100            |   25 +++
>  drivers/net/intel_wired_lan/Kconfig.1000           |  102 ++++++++++
>  drivers/net/intel_wired_lan/Kconfig.10000          |   81 ++++++++
>  drivers/net/intel_wired_lan/Makefile               |    9 +
>  drivers/net/{ => intel_wired_lan}/e100.c           |    0
>  drivers/net/{ => intel_wired_lan}/e1000/Makefile   |    0
>  drivers/net/{ => intel_wired_lan}/e1000/e1000.h    |    0
>  .../{ => intel_wired_lan}/e1000/e1000_ethtool.c    |    0
>  drivers/net/{ => intel_wired_lan}/e1000/e1000_hw.c |    0
>  drivers/net/{ => intel_wired_lan}/e1000/e1000_hw.h |    0
>  .../net/{ => intel_wired_lan}/e1000/e1000_main.c   |    0
>  .../net/{ => intel_wired_lan}/e1000/e1000_osdep.h  |    0
>  .../net/{ => intel_wired_lan}/e1000/e1000_param.c  |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/82571.c   |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/Makefile  |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/defines.h |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/e1000.h   |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/es2lan.c  |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/ethtool.c |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/hw.h      |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/ich8lan.c |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/lib.c     |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/netdev.c  |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/param.c   |    0
>  drivers/net/{ => intel_wired_lan}/e1000e/phy.c     |    0
>  drivers/net/{ => intel_wired_lan}/igb/Makefile     |    0
>  .../net/{ => intel_wired_lan}/igb/e1000_82575.c    |    0
>  .../net/{ => intel_wired_lan}/igb/e1000_82575.h    |    0
>  .../net/{ => intel_wired_lan}/igb/e1000_defines.h  |    0
>  drivers/net/{ => intel_wired_lan}/igb/e1000_hw.h   |    0
>  drivers/net/{ => intel_wired_lan}/igb/e1000_mac.c  |    0
>  drivers/net/{ => intel_wired_lan}/igb/e1000_mac.h  |    0
>  drivers/net/{ => intel_wired_lan}/igb/e1000_mbx.c  |    0
>  drivers/net/{ => intel_wired_lan}/igb/e1000_mbx.h  |    0
>  drivers/net/{ => intel_wired_lan}/igb/e1000_nvm.c  |    0
>  drivers/net/{ => intel_wired_lan}/igb/e1000_nvm.h  |    0
>  drivers/net/{ => intel_wired_lan}/igb/e1000_phy.c  |    0
>  drivers/net/{ => intel_wired_lan}/igb/e1000_phy.h  |    0
>  drivers/net/{ => intel_wired_lan}/igb/e1000_regs.h |    0
>  drivers/net/{ => intel_wired_lan}/igb/igb.h        |    0
>  .../net/{ => intel_wired_lan}/igb/igb_ethtool.c    |    0
>  drivers/net/{ => intel_wired_lan}/igb/igb_main.c   |    0
>  drivers/net/{ => intel_wired_lan}/igbvf/Makefile   |    0
>  drivers/net/{ => intel_wired_lan}/igbvf/defines.h  |    0
>  drivers/net/{ => intel_wired_lan}/igbvf/ethtool.c  |    0
>  drivers/net/{ => intel_wired_lan}/igbvf/igbvf.h    |    0
>  drivers/net/{ => intel_wired_lan}/igbvf/mbx.c      |    0
>  drivers/net/{ => intel_wired_lan}/igbvf/mbx.h      |    0
>  drivers/net/{ => intel_wired_lan}/igbvf/netdev.c   |    0
>  drivers/net/{ => intel_wired_lan}/igbvf/regs.h     |    0
>  drivers/net/{ => intel_wired_lan}/igbvf/vf.c       |    0
>  drivers/net/{ => intel_wired_lan}/igbvf/vf.h       |    0
>  drivers/net/{ => intel_wired_lan}/ixgb/Makefile    |    0
>  drivers/net/{ => intel_wired_lan}/ixgb/ixgb.h      |    0
>  drivers/net/{ => intel_wired_lan}/ixgb/ixgb_ee.c   |    0
>  drivers/net/{ => intel_wired_lan}/ixgb/ixgb_ee.h   |    0
>  .../net/{ => intel_wired_lan}/ixgb/ixgb_ethtool.c  |    0
>  drivers/net/{ => intel_wired_lan}/ixgb/ixgb_hw.c   |    0
>  drivers/net/{ => intel_wired_lan}/ixgb/ixgb_hw.h   |    0
>  drivers/net/{ => intel_wired_lan}/ixgb/ixgb_ids.h  |    0
>  drivers/net/{ => intel_wired_lan}/ixgb/ixgb_main.c |    0
>  .../net/{ => intel_wired_lan}/ixgb/ixgb_osdep.h    |    0
>  .../net/{ => intel_wired_lan}/ixgb/ixgb_param.c    |    0
>  drivers/net/{ => intel_wired_lan}/ixgbe/Makefile   |    0
>  drivers/net/{ => intel_wired_lan}/ixgbe/ixgbe.h    |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_82598.c  |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_82599.c  |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_common.c |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_common.h |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_dcb.c    |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_dcb.h    |    0
>  .../{ => intel_wired_lan}/ixgbe/ixgbe_dcb_82598.c  |    0
>  .../{ => intel_wired_lan}/ixgbe/ixgbe_dcb_82598.h  |    0
>  .../{ => intel_wired_lan}/ixgbe/ixgbe_dcb_82599.c  |    0
>  .../{ => intel_wired_lan}/ixgbe/ixgbe_dcb_82599.h  |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_dcb_nl.c |    0
>  .../{ => intel_wired_lan}/ixgbe/ixgbe_ethtool.c    |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_fcoe.c   |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_fcoe.h   |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_main.c   |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_mbx.c    |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_mbx.h    |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_phy.c    |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_phy.h    |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_sriov.c  |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_sriov.h  |    0
>  .../net/{ => intel_wired_lan}/ixgbe/ixgbe_type.h   |    0
>  drivers/net/{ => intel_wired_lan}/ixgbevf/Makefile |    0
>  .../net/{ => intel_wired_lan}/ixgbevf/defines.h    |    0
>  .../net/{ => intel_wired_lan}/ixgbevf/ethtool.c    |    0
>  .../net/{ => intel_wired_lan}/ixgbevf/ixgbevf.h    |    0
>  .../{ => intel_wired_lan}/ixgbevf/ixgbevf_main.c   |    0
>  drivers/net/{ => intel_wired_lan}/ixgbevf/mbx.c    |    0
>  drivers/net/{ => intel_wired_lan}/ixgbevf/mbx.h    |    0
>  drivers/net/{ => intel_wired_lan}/ixgbevf/regs.h   |    0
>  drivers/net/{ => intel_wired_lan}/ixgbevf/vf.c     |    0
>  drivers/net/{ => intel_wired_lan}/ixgbevf/vf.h     |    0
>  107 files changed, 224 insertions(+), 233 deletions(-)
>

NAK
I agree with Stephen that this will generate a lot of confusion and....

First, I think we need to keep the documentation in /Documentation/networking.
Second, the changes are extensive and would create a lot of regression testing.

We have been looking at solutions like this for future
drivers/hardware and is on the list of items we are currently working
on, but feel it should not be made retroactively due to the regression
testing and massive changes that would need to be made.

-- 
Cheers,
Jeff
