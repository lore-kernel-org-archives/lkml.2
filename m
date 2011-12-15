Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab1LOXLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:11:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645Ab1LOXLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:11:11 -0500
Date: Thu, 15 Dec 2011 15:08:33 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Namhyung Kim <namhyung@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Update][PATCH 0/5] PM: Make the PM core execute driver
 callbacks if subsystem ones are not present
Message-ID: <20111215230833.GA27281@suse.de>
References: <201112100018.38536.rjw@sisk.pl>
 <201112152334.16527.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112152334.16527.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:34:16PM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> I have one more patch for this series and a couple of fixes.
> 
> On Saturday, December 10, 2011, Rafael J. Wysocki wrote:
> > 
> > The following patchset changes the PM core so that driver callbacks
> > are executed automatically when subsystem ones are not present and
> > uses the new PM core's behavior to simplify the platform and AMBA bus
> > types (there probably are many more bus types that may be simplified
> > this way, but those two were the easiest targets for me).
> > 
> > The reasons why to do this are outlined in the changelog of the second patch.
> 
> [1/5] - Make pm_op and pm_noirq_op return callbacks
> [2/5] - Make PM core call driver callbacks directly if subsystem ones are not present
> [3/5] - Remove unnecessary bus type PM callback from platform bus type
> [4/5] - Remove unnecessary bus type PM callback from AMBA bus type
> [5/5] - Drop generic_subsys_pm_ops
> 
> If there are no objections, I'd like to take these patches for 3.3.

No objection from me, thanks for doing this.

greg k-h
