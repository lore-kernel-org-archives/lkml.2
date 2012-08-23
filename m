Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033Ab2HWNsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:48:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47503 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933649Ab2HWNsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:48:39 -0400
Date: Thu, 23 Aug 2012 14:48:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Sebastian Poehn <sebastian.poehn@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] dell-laptop: Caused by "Remove rfkill code" commit
Message-ID: <20120823134836.GA18857@srcf.ucam.org>
References: <1345726401.1481.8.camel@localhost.localdomain>
 <20120823131458.GA18067@srcf.ucam.org>
 <1345729603.1503.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1345729603.1503.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 03:46:43PM +0200, Sebastian Poehn wrote:
> On Thu, 2012-08-23 at 14:14 +0100, Matthew Garrett wrote:
> > On Thu, Aug 23, 2012 at 02:53:21PM +0200, Sebastian Pöhn wrote:
> > 
> > > As rfkill can not get the state of the physical kill-switch, both state may differ.
> > 
> > b43 should know the state of the physical rfkill switch even if there's 
> > no platform code to support it.
> > 
> BCM 4313 is _only_ supported by BCMs proprietar driver and brcmsmac; and
> the later one I use.

Ok, well definitely seems like a bug in brcmsmac.

> Further there should be problems with other Wifis, like Intel?

Why?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
