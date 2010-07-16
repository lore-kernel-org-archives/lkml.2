Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935973Ab0GPI1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 04:27:13 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40935 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935847Ab0GPI1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 04:27:10 -0400
Date: Fri, 16 Jul 2010 04:27:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@lynx
To: Greg KH <greg@kroah.com>
cc: Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value in running my kernel scanning scripts before
 release?
In-Reply-To: <20100716030012.GA26610@kroah.com>
Message-ID: <alpine.DEB.2.00.1007160425560.13582@lynx>
References: <alpine.DEB.2.00.1007150728520.13042@lynx> <4C3F0D1B.9060403@suse.cz> <alpine.DEB.2.00.1007151845490.11593@lynx> <20100716030012.GA26610@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Greg KH wrote:

> On Thu, Jul 15, 2010 at 06:50:20PM -0400, Robert P. J. Day wrote:

> > ===== USB_ETH_FUNCTIONFS =====
> > ./drivers/usb/gadget/Makefile:obj-$(CONFIG_USB_ETH_FUNCTIONFS)	+= g_eth_ffs.o
>
> Ah, ick, that usb functionfs one is a real bug, nice catch.  I too
> have been getting no sleep, and will just wait for you to send me a
> patch :)

  just submitted patch on linux USB list ...

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
