Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0EJMKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:10:31 -0400
Received: from smtp.nokia.com ([192.100.122.230]:64813 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab0EJMK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:10:29 -0400
Date: Mon, 10 May 2010 15:13:05 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
       Ambresh <a0393775@ti.com>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [PATCHv4 3/4] mach-omap1: export omap1 info under /proc/socinfo
Message-ID: <20100510121305.GB8441@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
 <1273487857-32281-4-git-send-email-eduardo.valentin@nokia.com>
 <20100510105200.GA14337@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510105200.GA14337@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 May 2010 12:09:42.0427 (UTC) FILETIME=[AC13EEB0:01CAF039]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 12:52:00PM +0200, Russell King wrote:
> On Mon, May 10, 2010 at 01:37:36PM +0300, Eduardo Valentin wrote:
> > From: Eduardo Valentin <eduardo.valentin@nokia.com>
> > 
> > Report OMAP name and rev under /proc/socinfo node.
> 
> I think this needs to be combined with the previous patch.  The previous
> patch enables the socinfo file, which means with patch 2 applied but not
> patch 3, OMAP1 breaks.

yes, indeed. I will squash both.

Tks,

--
Eduardo Valentin
