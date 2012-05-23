Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965130Ab2EWGdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:33:23 -0400
Received: from linux-sh.org ([111.68.239.195]:54056 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965118Ab2EWGdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:33:17 -0400
Date: Wed, 23 May 2012 15:32:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, horms@verge.net.au,
        linux-sh@vger.kernel.org, johnstul@us.ibm.com, rjw@sisk.pl,
        gregkh@linuxfoundation.org, olof@lixom.net, tglx@linutronix.de
Subject: Re: [PATCH 01/03] clockevents: Make clockevents_config() a global
 symbol
Message-ID: <20120523063218.GB11860@linux-sh.org>
References: <20120509143926.27521.20342.sendpatchset@w520>
 <20120509143934.27521.46553.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509143934.27521.46553.sendpatchset@w520>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:39:34PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Make clockevents_config() into a global symbol to allow it
> to be used by compiled-in clockevent drivers. This is needed
> by drivers that want to update the timer frequency after
> registration time.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Any update on this?
