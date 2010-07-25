Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab0GYCZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 22:25:30 -0400
Received: from snt0-omc3-s29.snt0.hotmail.com ([65.55.90.168]:54756 "EHLO
	snt0-omc3-s29.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab0GYCZ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 22:25:29 -0400
Message-ID: <SNT125-W2517DC4443F08A6B394802C3A50@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <greg.freemyer@gmail.com>
CC: <tj@kernel.org>, <jeff@garzik.org>, <ben.collins@ubuntu.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hmh@debian.org>
Subject: RE: support for drives larger than 2TiB
Date: Sat, 24 Jul 2010 19:25:28 -0700
Importance: Normal
In-Reply-To: <AANLkTi=-0Hdp2dfK_RB=w-W8Qm8O42dDM0ybEcRtEMdn@mail.gmail.com>
References: <4C4AB952.9030705@kernel.org>,<SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl>,<AANLkTi=-0Hdp2dfK_RB=w-W8Qm8O42dDM0ybEcRtEMdn@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Jul 2010 02:25:28.0506 (UTC) FILETIME=[A5B511A0:01CB2BA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 64-bit LBA? I assume you meant 48-bit LBA from ATA-7. It will
> address up to PBs I believe. (KB, MB, GB, TB, PB, ....)
Yes, the sector number in Int13 extensions really is 64-bit.
Look at the Ralf Brown Interrupt List, for example.

Yuhong Bao
 		 	   		  
_________________________________________________________________
The New Busy is not the old busy. Search, chat and e-mail from your inbox.
http://www.windowslive.com/campaign/thenewbusy?ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_3