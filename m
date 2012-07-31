Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2GaGIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:08:07 -0400
Received: from linux-sh.org ([111.68.239.195]:49803 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab2GaGIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:08:05 -0400
Date: Tue, 31 Jul 2012 15:07:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, "Koul, Vinod" <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] serial: sh-sci: fix compilation breakage (3.6)
Message-ID: <20120731060754.GB15380@linux-sh.org>
References: <Pine.LNX.4.64.1207302114440.28003@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1207302114440.28003@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 09:28:18PM +0200, Guennadi Liakhovetski wrote:
> Hi all
> 
> as has been reported in this
> 
> http://thread.gmane.org/gmane.linux.kernel/1294256/focus=16001
> 
> thread, currently sh-sci doesn't comiple in the mainline and in -next if 
> CONFIG_SERIAL_SH_SCI_DMA is enabled. This patch series fixes this 
> breakage.
> 
Looks alright to me. Vinod, how do you want to handle this? I can roll
both of these patches in to my tree with your Acked-by, or I can provide
you with mine for the sh-sci bits if you want to take it via yours. I'm
planning on sending my next round of updates to Linus in the next couple
of days.
