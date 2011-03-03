Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1CCISW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:18:22 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:33784 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649Ab1CCISU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:18:20 -0500
Date: Thu, 3 Mar 2011 10:18:14 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hema HK <hemahk@ti.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, Thomas Weber <weber@corscience.de>
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
Message-ID: <20110303081814.GA2644@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110302165746.814a45a3.sfr@canb.auug.org.au>
 <20110302142322.GA2889@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302142322.GA2889@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 09:23:22AM -0500, Greg KH wrote:
> On Wed, Mar 02, 2011 at 04:57:46PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the usb tree got a conflict in
> > drivers/usb/musb/musb_core.h between commit
> > 59b479e0985f0b795d68331d6443a7f89c47768d ("omap: Start using
> > CONFIG_SOC_OMAP") from the omap tree and commit
> > da68ccec210c45eb99e461ad31b499b4e7043c41 ("usb: musb: Remove platform
> > context save/restore API") from the usb tree.
> > 
> > The latter removed the code modified by the former, so I did that.
> 
> Thanks.  I'll let Felipe handle all of these omap merge issues, as I
> thought the reason I was going to take these patches from him was to
> prevent issues like this from happening :)

Fixing, will send patches to Tony to avoid the conflict.

-- 
balbi
