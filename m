Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2GXQYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:24:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57093 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530Ab2GXQYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:24:25 -0400
Date: Tue, 24 Jul 2012 17:24:04 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [08/36] AArch64: Kernel booting and initialisation
Message-ID: <20120724162404.GB29519@arm.com>
References: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
 <500DB986.7090309@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500DB986.7090309@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 09:52:22PM +0100, Christopher Covington wrote:
> Hi Catalin and Stephen,
> 
> Catalin Marinas - July 8, 2012, 9:18 a.m.
> > On Fri, Jul 06, 2012 at 10:32:54PM +0100, Stephen Warren wrote:
> > 
> >> Also, on Tegra at least and perhaps OMAP too, there are a few parts
> >> of earlyprintk serial port setup (i.e. port selection) which happen
> >> as part of the decompressor rather than the main kernel image, so
> >> we'd have to re-jig that too.
> > 
> > Whatever we did on AArch32, if it was useful and we want to follow a
> > similar model it needs porting given that the code cannot be shared. So
> > there is nothing to re-jig but rather implement.
> > 
> > As for earlyprintk, you can initialise it in the decompressed kernel
> > anyway. But even though it's a useful debugging tool, it goes against
> > the single Image aim (at least the current printascii/addruart
> > implementation). I don't have a proper implementation yet.
> 
> Would DCC [1] be a reasonably commonly available early printk mechanism
> for the single image to provide?

Yes, this can be implemented but I think it has its own restrictions,
requiring a JTAG connection.

-- 
Catalin
