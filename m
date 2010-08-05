Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761028Ab0HEWhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:37:12 -0400
Received: from kroah.org ([198.145.64.141]:41646 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933612Ab0HEWhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:37:06 -0400
Date: Thu, 5 Aug 2010 15:36:49 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Kosina <jkosina@suse.cz>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P.Mattock" <justinmattock@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with Linus' tree
Message-ID: <20100805223649.GD18619@kroah.com>
References: <20100805132208.74bf6ab9.sfr@canb.auug.org.au>
 <alpine.LNX.2.00.1008051216260.29919@pobox.suse.cz>
 <op.vgynpf0k7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vgynpf0k7p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 12:35:29PM +0200, Michał Nazarewicz wrote:
> On Thu, 05 Aug 2010 12:17:05 +0200, Jiri Kosina <jkosina@suse.cz> wrote:
> 
> >On Thu, 5 Aug 2010, Stephen Rothwell wrote:
> >
> >>Today's linux-next merge of the usb tree got a conflict in
> >>Documentation/usb/linux.inf between commit
> >>0ea6e61122196509af82cc4f36cbdaacbefb8227 ("Documentation: update broken
> >>web addresses") from Linus' tree and commit
> >>2e73ce9389be011587a0ca581b6798b135e64807 ("USB: gadget: g_ether: updated
> >>INF file") from the usb tree.
> >>
> >>The URL that was fixed by the former was removed by the latter, so I just
> >>used the latter version.
> >
> >I see. Greg, will you just rebase the patch in USB tree on top of current
> >Linus' tree please?
> 
> It should be enough to add this delta to the "USB: gadget: g_ether: updated
> INF file":
> 
> -;   http://www.microsoft.com/whdc/hwdev/resources/HWservices/rndis.mspx
> +;   http://www.microsoft.com/whdc/device/network/ndis/rmndis.mspx

I've fixed this up in my tree now.

thanks,

greg k-h
