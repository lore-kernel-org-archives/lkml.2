Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2ITH4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:56:06 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:58614 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2ITH4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:56:04 -0400
Date: Thu, 20 Sep 2012 07:56:03 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, bbruce@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        khilman@ti.com, santosh.shilimkar@ti.com, jon-hunter@ti.com,
        snijsure@grid-net.com
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
In-Reply-To: <20120920000351.GI2455@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
References: <alpine.DEB.2.00.1209122237080.7275@utopia.booyaka.com> <20120913011208.GT4257@linux.vnet.ibm.com> <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com> <20120920000351.GI2455@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 19 Sep 2012, Paul E. McKenney wrote:

> On Thu, Sep 13, 2012 at 06:52:10PM +0000, Paul Walmsley wrote:
> 
> > On Wed, 12 Sep 2012, Paul E. McKenney wrote:
>  
> > > Subodh Nijsure (also CCed) reported something that might be similar on
> > > ARM, and also reported that setting the following got rid of the stalls:
> > > 
> > > 	CONFIG_CPU_IDLE=y
> > > 	CONFIG_CPU_IDLE_GOV_LADDER=y
> > > 	CONFIG_CPU_IDLE_GOV_MENU=y
> > > 
> > > At which point he was happy, which was good, but which also left the
> > > underlying problem unsolved.  Do these affect your system?  If so,
> > > do they cause a different ARM idle loop to be executed?
> > 
> > Will give this a try.  What board was Subodh using?
> 
> Any news on trying the above settings?

Sorry, haven't had the chance to try it yet due to the impending merge 
window opening.  Once things settle down I'll give it a try -- or maybe 
someone else can test it in the meantime.


- Paul
