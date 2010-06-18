Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0FRCHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:07:33 -0400
Received: from snt0-omc2-s7.snt0.hotmail.com ([65.55.90.82]:60429 "EHLO
	snt0-omc2-s7.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089Ab0FRCHc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:07:32 -0400
Message-ID: <SNT125-W601D37A89A8CBFFDFFF40EC3C00@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>, <kees.cook@canonical.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
       <mingo@redhat.com>, <tabbott@ksplice.com>, <sam@ravnborg.org>,
       <heukelum@fastmail.fm>
Subject: RE: [PATCH] x86: clear XD_DISABLED flag on Intel to regain NX
Date: Thu, 17 Jun 2010 19:07:31 -0700
Importance: Normal
In-Reply-To: <4C1AA15E.3050205@zytor.com>
References: <20100617221318.GC24749@outflux.net>,<4C1AA15E.3050205@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Jun 2010 02:07:31.0984 (UTC) FILETIME=[02C41900:01CB0E8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> a) Not all Intel CPUs with extended CPUID levels have
> MSR_IA32_MISC_ENABLE bit 34. Since we can't take traps here we would
> have to know positively that we aren't going to trip on anything.
It won't as these older Intel CPUs are always going to read this bit as zero, and even if no checking for this is include all the wrmsr would do is write the same value back, which won't cause a trap.

Yuhong Bao
 		 	   		  
_________________________________________________________________
Hotmail has tools for the New Busy. Search, chat and e-mail from your inbox.
http://www.windowslive.com/campaign/thenewbusy?ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_1