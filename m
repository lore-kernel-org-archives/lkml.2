Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0EGWfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:35:40 -0400
Received: from mga05.intel.com ([192.55.52.89]:24128 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752679Ab0EGWfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:35:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,350,1270450800"; 
   d="scan'208";a="796496223"
Message-ID: <4BE495BA.3040905@linux.intel.com>
Date: Fri, 07 May 2010 15:35:38 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Feng Tang <feng.tang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFD: Should we remove the HLT check?  (was Re: [PATCH 1/8] x86:
 avoid check hlt if no timer interrupts)
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>	<1273254108-3234-2-git-send-email-jacob.jun.pan@linux.intel.com>	<4BE478C1.2060602@zytor.com>	<4BE4791B.1060304@linux.intel.com>	<4BE479EA.3080005@zytor.com> <20100507232448.343b5ebc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100507232448.343b5ebc@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2010 15:24, Alan Cox wrote:
>> I'd be cool skipping it for family 5 or newer.  I'm just wondering if we
>> should kill it completely -- IIRC it was only a handful of 386/486
>> systems which had problems, usually due to marginal power supplies which
>> couldn't handle the noise of a variable load (DOS not having any power
>> management would run at a reliable 100% load) -- that's not exactly the
>> type of systems which would have survived to modern day.
>
> Also SMM and hardware bugs on some platforms - Cyrix MediaGX 5510 for
> example where a hlt at the wrong moment during ATA transfers hung the box
> until power cycle. But all old old stuff.

but a boot time "does hlt work at all" check won't catch that.
