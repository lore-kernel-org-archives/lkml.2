Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab0EGWIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:08:00 -0400
Received: from mga10.intel.com ([192.55.52.92]:45625 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750744Ab0EGWH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:07:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,350,1270450800"; 
   d="scan'208";a="565221039"
Date: Fri, 7 May 2010 15:07:48 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Feng Tang <feng.tang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Arjan van de Ven <arjan.van.de.ven@intel.com>
Subject: Re: RFD: Should we remove the HLT check?  (was Re: [PATCH 1/8] x86:
 avoid check hlt if no timer interrupts)
Message-ID: <20100507150748.00005a2d@unknown>
In-Reply-To: <4BE48051.1060604@zytor.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273254108-3234-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<4BE478C1.2060602@zytor.com>
	<4BE4791B.1060304@linux.intel.com>
	<alpine.LFD.2.00.1005071354310.901@i5.linux-foundation.org>
	<4BE48051.1060604@zytor.com>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Sounds like a plan.  Jacob, do you want to submit a new patch (bypassing
>this check if boot_cpu_info.x86 >= 5)?
>
>	-hpa
>
Just sent out the updated patch. I guess you meant boot_cpu_data instead of boot_cpu_info.
