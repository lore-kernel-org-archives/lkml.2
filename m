Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab0DYE2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 00:28:36 -0400
Received: from snt0-omc4-s24.snt0.hotmail.com ([65.55.90.227]:18487 "EHLO
	snt0-omc4-s24.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730Ab0DYE2e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 00:28:34 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Apr 2010 00:28:34 EDT
Message-ID: <SNT125-W32C1A34578F963A887460DC3050@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <andi@firstfloor.org>, <andre.przywara@amd.com>
CC: <jkosina@suse.cz>, <mingo@elte.hu>, <avi@redhat.com>,
       <mtosatti@redhat.com>, <joerg.roedel@amd.com>,
       <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: RE: KVM warning about uncertified CPU for SMP for AMD model 2,
 stepping 3
Date: Sat, 24 Apr 2010 21:22:24 -0700
Importance: Normal
In-Reply-To: <20100331125135.GW20695@one.firstfloor.org>
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz>
 <20100331024213.GV20695@one.firstfloor.org>
 <4BB33C0D.9090808@amd.com>,<20100331125135.GW20695@one.firstfloor.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Apr 2010 04:22:25.0272 (UTC) FILETIME=[E86F5780:01CAE42E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The point was that everyone can have a multi-core system for cheap
> these days, no real motivation for anyone anymore to use old unsupported
> configurations to get one.
And BTW, another such old once common unsupported configuration that theLinux kernel never detected is the old dual Celerons. At first achieved byhacking slockets, later ABIT released the BP6 motherboard with dualSocket 370 specifically wired to allow this config. They were once commonamong the enthusiast community, Ars Technica among other review siteshad old articles about it.
Yuhong Bao 		 	   		  
_________________________________________________________________
The New Busy is not the too busy. Combine all your e-mail accounts with Hotmail.
http://www.windowslive.com/campaign/thenewbusy?tile=multiaccount&ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_4