Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2JVSTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:19:11 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36632 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab2JVSTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:19:08 -0400
Date: Mon, 22 Oct 2012 11:19:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        "David S. Miller" <davem@davemloft.net>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/32 v4] MIPS: Alchemy: use the ehci platform driver
Message-ID: <20121022181904.GA6077@kroah.com>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org>
 <1349701906-16481-9-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349701906-16481-9-git-send-email-florian@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 03:11:22PM +0200, Florian Fainelli wrote:
> Use the ehci platform driver power_{on,suspend,off} callbacks to perform the
> USB block gate enabling/disabling as what the ehci-au1xxx.c driver does.
> Update the db1200 and db1300 defconfigs to now select the EHCI platform
> driver.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---
> Changes in v4:
> - rebased against greg's latest usb-next
> 
> No changes in v3
> 
> Changes in v2:
> - update impacted alchemy defconfigs accordingly
> 
>  arch/mips/alchemy/common/platform.c |   23 ++++++++++++++++++++++-
>  arch/mips/configs/db1200_defconfig  |    1 +
>  arch/mips/configs/db1300_defconfig  |    1 +

These two defconfig files are no longer in Linus's tree, so I'll just
remove them from this patch.  If that's not ok, can you send a follow-on
patch that adds the config option to the correct defconfig file?

thanks,

greg k-h
