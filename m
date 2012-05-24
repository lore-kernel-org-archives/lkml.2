Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2EXK1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:27:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:49853 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab2EXK1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:27:20 -0400
Date: Thu, 24 May 2012 12:27:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, horms@verge.net.au, linux-sh@vger.kernel.org,
        johnstul@us.ibm.com, rjw@sisk.pl, gregkh@linuxfoundation.org,
        olof@lixom.net
Subject: Re: [PATCH 01/03] clockevents: Make clockevents_config() a global
 symbol
In-Reply-To: <20120523063218.GB11860@linux-sh.org>
Message-ID: <alpine.LFD.2.02.1205241225580.3231@ionos>
References: <20120509143926.27521.20342.sendpatchset@w520> <20120509143934.27521.46553.sendpatchset@w520> <20120523063218.GB11860@linux-sh.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Paul Mundt wrote:

> On Wed, May 09, 2012 at 11:39:34PM +0900, Magnus Damm wrote:
> > From: Magnus Damm <damm@opensource.se>
> > 
> > Make clockevents_config() into a global symbol to allow it
> > to be used by compiled-in clockevent drivers. This is needed
> > by drivers that want to update the timer frequency after
> > registration time.
> > 
> > Signed-off-by: Magnus Damm <damm@opensource.se>
> 
> Any update on this?

Ooops, I missed that. Can you take it through your tree with my
acked-by please?

Thanks,

	tglx
