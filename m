Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1BERoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:44:21 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51538 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab1BERoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:44:20 -0500
Date: Sat, 5 Feb 2011 17:44:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dell-wmi: Received unknown WMI event (0x11)
Message-ID: <20110205174417.GA28395@srcf.ucam.org>
References: <20110205171807.GA3738@legolas.emea.dhcp.ti.com> <20110205173259.GA28134@srcf.ucam.org> <20110205174124.GB2619@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110205174124.GB2619@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 07:41:25PM +0200, Felipe Balbi wrote:
> > 
> > Nothing's changed in dell-wmi in that timeframe, so I suspect it's some 
> > other issue that's triggering here and the hardware is responding by 
> > sending events? Alternatively, these messages are pretty spread out. Do 
> > they directly correspond to you trying to burn something?
> 
> it's actually right after inserting a disc on the drive. I'll try
> switching to AHCI on BIOS and see if it works fine.

And that message isn't generated in .37?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
