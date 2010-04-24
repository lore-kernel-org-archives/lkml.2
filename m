Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0DXBY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 21:24:26 -0400
Received: from relay.ihostexchange.net ([66.46.182.52]:26926 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0DXBYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 21:24:24 -0400
Message-ID: <4BD24841.1010206@VirtualLogix.com>
Date: Sat, 24 Apr 2010 03:24:17 +0200
From: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: USBIP (staging) driver's dependency on drivers/usb/core internal
 headers
References: <Pine.LNX.4.44L0.1004231402180.1777-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004231402180.1777-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 08:04 PM, Alan Stern wrote:
> On Fri, 23 Apr 2010, Eric Lescouet wrote:
> 
>> Well, most of the files include hcd.h (which includes hub.h),
>> only ~4 of them directly use hub.h.
> 
> Oh.  Okay, that makes life easier.  Probably some of the files which 
> include hub.h directly also include hcd.h.
> 
>> So what's your vote? rename hub.h into ch11.h?
> 
> Yeah, go ahead.  I like the idea of the kernel containing information 
> about Chapter 11.  (Although I haven't heard of anyone yet going 
> bankrupt as a result of using Linux...)
> 
> Alan Stern
> 

It looks like couple of files in drivers/usb/core and usb/host have been
modified already in latest snapshot (2.6.34-rc5-git5).
Is it still ok to provide the patches against the mainline (2.6.34-rc5)
or should I do it against the snapshot (2.6.34-rc5-git5)?

Thanks,
	Eric.
