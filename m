Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1BESJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 13:09:06 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:53427 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617Ab1BESJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 13:09:04 -0500
Date: Sat, 5 Feb 2011 20:08:59 +0200
From: Felipe Balbi <balbi@ti.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dell-wmi: Received unknown WMI event (0x11)
Message-ID: <20110205180859.GA2830@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110205171807.GA3738@legolas.emea.dhcp.ti.com>
 <20110205173259.GA28134@srcf.ucam.org>
 <20110205174124.GB2619@legolas.emea.dhcp.ti.com>
 <20110205174417.GA28395@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110205174417.GA28395@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 05:44:17PM +0000, Matthew Garrett wrote:
> On Sat, Feb 05, 2011 at 07:41:25PM +0200, Felipe Balbi wrote:
> > > 
> > > Nothing's changed in dell-wmi in that timeframe, so I suspect it's some 
> > > other issue that's triggering here and the hardware is responding by 
> > > sending events? Alternatively, these messages are pretty spread out. Do 
> > > they directly correspond to you trying to burn something?
> > 
> > it's actually right after inserting a disc on the drive. I'll try
> > switching to AHCI on BIOS and see if it works fine.
> 
> And that message isn't generated in .37?

nope. dmesg is clean.

-- 
balbi
