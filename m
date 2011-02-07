Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1BGIZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:25:55 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:59952 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176Ab1BGIZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:25:53 -0500
Date: Mon, 7 Feb 2011 10:25:49 +0200
From: Felipe Balbi <balbi@ti.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dell-wmi: Received unknown WMI event (0x11)
Message-ID: <20110207082549.GA2580@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110205171807.GA3738@legolas.emea.dhcp.ti.com>
 <20110205173259.GA28134@srcf.ucam.org>
 <20110205174124.GB2619@legolas.emea.dhcp.ti.com>
 <20110205174417.GA28395@srcf.ucam.org>
 <20110205180859.GA2830@legolas.emea.dhcp.ti.com>
 <20110205181141.GA28947@srcf.ucam.org>
 <20110205181836.GC2830@legolas.emea.dhcp.ti.com>
 <20110205182015.GA29242@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110205182015.GA29242@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 06:20:15PM +0000, Matthew Garrett wrote:
> > ok, should we add more people to Cc then ?
> 
> Can you check by blacklisting dell-wmi and verifying that you still 
> can't burn?

it's the same. I also got the same messages on 2.6.37 after inserting a
second disk but still was able to burn the disc, so I don't think
dell-wmi is to blame here, like you said before.

-- 
balbi
