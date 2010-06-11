Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab0FKCRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 22:17:00 -0400
Received: from snt0-omc4-s8.snt0.hotmail.com ([65.55.90.211]:24302 "EHLO
	snt0-omc4-s8.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760100Ab0FKCQ6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 22:16:58 -0400
Message-ID: <SNT125-W1729A92F025BE180427F25C3D90@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <davidjon@xenontk.org>
CC: <arjan@infradead.org>, <ch@zeha.at>, <linux-kernel@vger.kernel.org>,
       <bruce.w.allan@intel.com>, <jpiszcz@lucidpixels.com>,
       <hpa@linux.intel.com>
Subject: RE: Linux* is not supported on the Intel(R) Desktop Board DP55KG -
 Kernel still hangs upon reboot.
Date: Thu, 10 Jun 2010 19:16:57 -0700
Importance: Normal
In-Reply-To: <4B420665.4090107@xenontk.org>
References: <20100103202345.GA20015@percival.namespace.at>
 <alpine.DEB.2.00.1001031637230.17894@p34.internal.lan>,<20100103150300.170dedee@infradead.org>
 <SNT125-W149307D1A737021C150C9CC3740@phx.gbl>,<4B420665.4090107@xenontk.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 Jun 2010 02:16:57.0471 (UTC) FILETIME=[2AEE50F0:01CB090C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> btw this can be automated... just needs a DMI quirk.
>>> someone needs to get dmidecode output and add it to the existing
>>> table of reboot= quirks...
>>>
>>> --
>>> Arjan van de Ven Intel Open Source Technology Centre
>>
>> Note BTW that this is one of Intel's own motherboards!
>> In fact, I also have read about Intel's own DG45FC board having EHCI handoff trouble with Linux.
>>
>
> Yes, but the BIOS is probably not done by Intel.

Except that they are, and what frustrates me is that some of the Linux developers involved in working around these bugs work at Intel in the first place, the same vendor that makes the motherboards with the buggy BIOSes! For example, Arjan from Intel is CCed right there!

Yuhong Bao
 		 	   		  
_________________________________________________________________
The New Busy is not the old busy. Search, chat and e-mail from your inbox.
http://www.windowslive.com/campaign/thenewbusy?ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_3