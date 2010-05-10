Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0EJNFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 09:05:04 -0400
Received: from smtp.nokia.com ([192.100.105.134]:22289 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0EJNE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 09:04:59 -0400
Date: Mon, 10 May 2010 16:08:09 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Cc: ext Paul Mundt <lethal@linux-sh.org>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
       Ambresh <a0393775@ti.com>
Subject: Re: [PATCHv4 1/4] procfs: Introduce socinfo under /proc
Message-ID: <20100510130809.GC11804@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
 <1273487857-32281-3-git-send-email-eduardo.valentin@nokia.com>
 <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
 <1273487857-32281-2-git-send-email-eduardo.valentin@nokia.com>
 <20100510111259.GA14680@linux-sh.org>
 <20100510125440.GA31721@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510125440.GA31721@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 May 2010 13:04:36.0546 (UTC) FILETIME=[57869A20:01CAF041]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 02:54:40PM +0200, Balbi Felipe (Nokia-D/Helsinki) wrote:
> On Mon, May 10, 2010 at 01:13:00PM +0200, ext Paul Mundt wrote:
> >You'll still need the show function, but all of the rest of this is just
> >duplicating what single_open() already does. If the socinfo string is
> >static you may also want to rework this a bit so you can just stash the
> >string in the proc_dir_entry private data. Combine this with something
> >like kstrdup() and you'll save yourself a bit of stack while you're at
> >it.
> 
> doesn't ksrtdup() cause memleak ?? Or is it only when used with 
> module parameters ??

I'm not aware of the module parameter stuff.. but the leak might be other thing
than kstrdup?
> 
> -- 
> balbi
> 
> DefectiveByDesign.org
