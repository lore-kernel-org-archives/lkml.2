Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab0FHUte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:49:34 -0400
Received: from snt0-omc2-s34.snt0.hotmail.com ([65.55.90.109]:27830 "EHLO
	snt0-omc2-s34.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755392Ab0FHUtd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:49:33 -0400
Message-ID: <SNT125-W5945752E67E4FDA7E5D813C3D60@phx.gbl>
X-Originating-IP: [164.116.126.146]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>, <linux@rainbow-software.org>
CC: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>, <gregkh@suse.de>
Subject: RE: Windows side agrees that lowmem corruption is a problem too
Date: Tue, 8 Jun 2010 13:49:32 -0700
Importance: Normal
In-Reply-To: <4C0EA8A1.4020801@zytor.com>
References: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl>
 <4C0E949D.6090002@zytor.com> <20100608190848.GD25985@elte.hu>
 <201006082122.25089.linux@rainbow-software.org>,<4C0EA8A1.4020801@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2010 20:49:32.0981 (UTC) FILETIME=[19138650:01CB074C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Disusing 64K is something we can do unconditionally (especially since
> we're only talking about 60K -- 15 pages -- of actually usable memory
> anyway.)
Unless you really have no extended memory, agreed.
> Dropping all the low 0.6 MB (which is what it really is) is probably
> unacceptable by default, but perhaps it makes sense to use it only for
> ZONE_DMA or something.
For example, for really old 8-bit ISA devices that can only address 20-bit of address space and do not use the system 8237 DMA controller.
Yuhong Bao 		 	   		  
_________________________________________________________________
The New Busy think 9 to 5 is a cute idea. Combine multiple calendars with Hotmail. 
http://www.windowslive.com/campaign/thenewbusy?tile=multicalendar&ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_5