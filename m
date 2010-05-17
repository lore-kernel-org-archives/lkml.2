Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0EQPKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:10:50 -0400
Received: from snt0-omc3-s11.snt0.hotmail.com ([65.55.90.150]:5715 "EHLO
	snt0-omc3-s11.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab0EQPKt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:10:49 -0400
Message-ID: <SNT125-W19B1FC8CF2BAD793767B91C3E00@phx.gbl>
X-Originating-IP: [164.116.126.146]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <andreas.herrmann3@amd.com>
CC: <venkatesh.pallipadi@intel.com>, <markh@compro.net>, <dmarkh@cfl.rr.com>,
       <andi@firstfloor.org>, <torvalds@linux-foundation.org>,
       <alain@knaff.lu>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
Date: Mon, 17 May 2010 08:10:48 -0700
Importance: Normal
In-Reply-To: <20100517145943.GV5888@alberich.amd.com>
References: <87bphpd4rt.fsf@basil.nowhere.org>,<4B32565E.6000501@compro.net>,<20091223191806.GA3336@linux-os.sc.intel.com>,<4B3270FE.5090607@compro.net>,<1261600243.16916.56.camel@localhost.localdomain>,<4B476E8D.1030308@compro.net>,<20100121190952.GA32523@linux-os.sc.intel.com>,<SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl>,<20100125171059.GB5041@alberich.amd.com>,<20100517145943.GV5888@alberich.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 17 May 2010 15:10:48.0868 (UTC) FILETIME=[21DF7E40:01CAF5D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The suggested workaround for this is to disable HPET MSI if LPC
> devices are used. I doubt that there is a convenient way for Linux to
> find out whether LPC devices are used.And don't forget that the Super I/O chip in most motherboards is an LPC device!(In fact, that was what LPC was invented for)
> Thus I think the only solution
> to safely avoid the problem is the currently implemented quirk to
> disable HPET MSI on this chipset.
Yuhong Bao

 		 	   		  
_________________________________________________________________
The New Busy is not the too busy. Combine all your e-mail accounts with Hotmail.
http://www.windowslive.com/campaign/thenewbusy?tile=multiaccount&ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_4