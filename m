Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab2CSTq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:46:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40357 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759349Ab2CSTq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:46:57 -0400
Date: Mon, 19 Mar 2012 12:46:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Olof Johansson <olof@lixom.net>, Dan Williams <dan.j.williams@intel.com>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: iop: add missing includes
Message-ID: <20120319194653.GA9308@kroah.com>
References: <1329344682-29962-1-git-send-email-olof@lixom.net>
 <20120319194016.GA708@ultra.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319194016.GA708@ultra.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 09:40:16PM +0200, Aaro Koskinen wrote:
> Hi,
> 
> On Wed, Feb 15, 2012 at 02:24:42PM -0800, Olof Johansson wrote:
> > Resolves two build breaks. One is a boatload of "unknown type name 'u32'"
> > in iop3xx.h due to missing include of <linux/types.h>.
> > 
> > The other is:
> > arch/arm/plat-iop/restart.c: In function 'iop3xx_restart':
> > arch/arm/plat-iop/restart.c:18:2: error: implicit declaration of function 'soft_restart' [-Werror=implicit-function-declaration]
> > 
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> Any chance to get this patch into 3.3.1 (stable), when and if such is made?
> 
> The v3.3 fails to build for IOP boards without this.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
