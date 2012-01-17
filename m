Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2AQQGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:06:21 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40030 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013Ab2AQQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:06:19 -0500
X-Sasl-enc: pNMfXSeJlgeObs1slO5Kw8aPSE/8Mnr10vMdxnkW6Ccw 1326816379
Date: Tue, 17 Jan 2012 08:03:35 -0800
From: "greg@kroah.com" <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Message-ID: <20120117160335.GA27679@kroah.com>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com>
 <331ABD5ECB02734CA317220B2BBEABC13177CDA4@DBDE01.ent.ti.com>
 <20120117105441.GC2944@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117105441.GC2944@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 10:54:42AM +0000, Mark Brown wrote:
> On Tue, Jan 17, 2012 at 07:32:47AM +0000, AnilKumar, Chimata wrote:
> 
> > Recalling the patch, provide the comments if there are any if not please include
> > this patch to v3.3 kernel.
> 
> There's no way this is going to make it into the 3.3 kernel at this
> point, we're almost at the end of the merge window.

Agreed, the merge window is for subsystem maintainers, not everyone
else.  I'll queue this up for review for after 3.3-rc1 is out.

thanks,

greg k-h
