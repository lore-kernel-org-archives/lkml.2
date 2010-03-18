Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0CRXAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 19:00:06 -0400
Received: from lucidpixels.com ([75.144.35.66]:41709 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0CRXAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 19:00:04 -0400
Date: Thu, 18 Mar 2010 19:00:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: 2.6.34-rc1: pci 0000:00:00.0: address space collision / spontaenous
 reboots [now 2.6.34-rc1]
In-Reply-To: <201003181658.38462.bjorn.helgaas@hp.com>
Message-ID: <alpine.DEB.2.00.1003181858590.27400@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan> <4B9AB7AE.7000002@kernel.org> <alpine.DEB.2.00.1003121859240.6929@p34.internal.lan> <201003181658.38462.bjorn.helgaas@hp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Mar 2010, Bjorn Helgaas wrote:

> On Saturday 13 March 2010 02:01:32 am Justin Piszcz wrote:
>> It stayed up for approximately 8-9 hours, then it crashed again.
>>
>> It is either a DOA motherboard OR the memory mapping is causing problems..
>
> Hi Justin,
>
> Did you ever make any more progress on this?  I don't have any ideas;
> just wondering whether you learned anything.
>
> Bjorn
>

Hello,

I swapped the motherboard with the ASUS and all problems have disappeared. 
Someone else e-mailed me with a similar issue (freeze/hang/etc) with a 
similar motherboard (but UDP3 instead of 5 I believe) and they could not 
find a solution either, they were trying to install Fedora.

Justin.
