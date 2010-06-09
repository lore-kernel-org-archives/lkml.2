Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab0FIBIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 21:08:32 -0400
Received: from snt0-omc2-s28.snt0.hotmail.com ([65.55.90.103]:27079 "EHLO
	snt0-omc2-s28.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782Ab0FIBIb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 21:08:31 -0400
Message-ID: <SNT125-W33637A89CB95EFC6020F3BC3D70@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>, <alan@lxorguk.ukuu.org.uk>
CC: <linux@rainbow-software.org>, <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <gregkh@suse.de>
Subject: RE: Windows side agrees that lowmem corruption is a problem too
Date: Tue, 8 Jun 2010 18:08:30 -0700
Importance: Normal
In-Reply-To: <4C0EBCE1.2070609@zytor.com>
References: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl>
	<4C0E949D.6090002@zytor.com>	<20100608190848.GD25985@elte.hu>
	<201006082122.25089.linux@rainbow-software.org>
 <20100608225656.7f645621@lxorguk.ukuu.org.uk>,<4C0EBCE1.2070609@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Jun 2010 01:08:30.0796 (UTC) FILETIME=[4655F0C0:01CB0770]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> It has to be painful to the vendors so they get complaints, reports and
>> support call costs. Otherwise they won't have the correct incentives to
>> fix their mess.
Notice that Windows 7 logs an event log entry when this is detected during sleep, even though they don't use the low meg at all.
> We have already functionally lost 64K on all existing machines... I
> think the current blacklist covers 90% or more of all systems in
> existence, and we keep filling in the few holes that remain.
Which was why I said it was too broad.

If you really mean to do it unconditionally, just do it unconditionally.

Yuhong Bao
 		 	   		  
_________________________________________________________________
The New Busy is not the old busy. Search, chat and e-mail from your inbox.
http://www.windowslive.com/campaign/thenewbusy?ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_3