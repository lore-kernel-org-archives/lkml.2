Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1DEIVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:21:20 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:46422 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1DEIVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:21:17 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Apr 2011 04:21:16 EDT
Message-ID: <4D9ACFC1.4080608@davidnewall.com>
Date: Tue, 05 Apr 2011 17:46:01 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-AU; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: nonzero write bulk status received: -62
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting the above error on a recent installation, when printing to a 
USB connected printer, and only the first half of the page is printed.  
Searching Google, I found that this is surprisingly common (I was 
surprised), both using usb parallel converters as well as usb-connected 
printers, and the only suggestion seems to be to change CUPS's device 
URI to parallel:/dev/usb/lpN - it's currently 
usb://OKI%20MICROLINE%20something.  (Even though it seems somewhat 
bizarre, I am trying the suggestion, but haven't heard the results yet.)

 From UTSLing I see that error 62 is ETIME, but finding the timer 
involved requires getting arms-deep into the USB code.  I found no 
discussion on this, and wonder if I just missed it, or if there really 
is some issue that worth looking at.  Something about extended output 
and ETIME makes me think it is worth looking at.

I'd appreciate pointers, either to discussions and solutions that I 
missed, or to places in the code where I might start looking.

Thanks.
