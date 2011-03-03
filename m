Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1CCKiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:38:20 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:53895 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783Ab1CCKiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:38:19 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABv+bk1R8KK1/2dsb2JhbACmdHW+Zg2FVAQ
Date: Thu, 3 Mar 2011 11:38:14 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 5/10] Generic Watchdog Timer Driver
Message-ID: <20110303103814.GA3790@infomag.iguana.be>
References: <20110223204330.GA7417@infomag.iguana.be> <201102240921.02967.alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102240921.02967.alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

> On Wednesday 23 February 2011, 21:43:30 Wim Van Sebroeck wrote:
> > commit 1959ea403c69af855f5cd13e5c9b33123d2137b2
> > Author: Wim Van Sebroeck <wim@iguana.be>
> > Date:   Fri Jun 18 09:45:49 2010 +0000
> > 
> >     watchdog: WatchDog Timer Driver Core - Part 5
> > 
> >     This part add's the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
> >     functionality to the WatchDog Timer Driver Core framework.
> > 
> >     Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> >     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> > 
> > [snip]
> 
> Any specific reason you can only specify seconds as timeout? There is no way 
> to set a timeout of e.g. 500ms or 1500ms.
> You can change this by using using a struct timeval for setting a timeout. 
> What do you think?

1) The current ioctl call is like this in all drivers. So changing it would break things.
2) Is there a real need for having 500ms or 1500ms? why would 1 or 2 seconds not be OK? (which are allready small timeouts for userspace anyway...)

Kind regards,
Wim.

