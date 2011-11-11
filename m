Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab1KKMhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 07:37:13 -0500
Received: from gimli.pitney-fabs.co.uk ([87.106.140.52]:46663 "EHLO
	gimli.pitney-fabs.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab1KKMhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 07:37:11 -0500
Date: Fri, 11 Nov 2011 12:37:07 +0000
From: Andrew Walrond <andrew@walrond.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: eth0/1 swapped places after kernel Upgrade 3.0.8 -> 3.1.0 (and
 udev 172 -> 174)
Message-ID: <20111111123707.GE1962@andrews-imac.pitney-fabs>
References: <20111102101404.GA5195@andrew-xps.home>
 <20111111114014.GA1962@andrews-imac.pitney-fabs>
 <20111111115617.4a352cc5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111111115617.4a352cc5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 11:56:17AM +0000, Alan Cox wrote:
> 
> The kernel probes them in whatever order it walks the PCI bus. What udev
> does afterwards is a distro question.
> 
> Does the order of the two probe reports every change or just the final
> udev result  - ie are they always found mac xx:xx:03 then xx:xx:05 ?

I've just rebooted half a dozen times and the order does not change. so I'll
go stare at the udev diffs and see if I can work out what has changed there.

Thanks for your help

Andrew Walrond
