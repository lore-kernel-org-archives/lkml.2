Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1E3FnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:43:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43246 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1E3FnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:43:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE32E66.6070301@jp.fujitsu.com>
Date: Mon, 30 May 2011 14:43:02 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 10/12] x86, mce: cleanup mce_read
References: <4DDF21DE.9040705@jp.fujitsu.com> <4DDF2476.1010903@jp.fujitsu.com> <20110527063804.GB16811@liondog.tnic>
In-Reply-To: <20110527063804.GB16811@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/27 15:38), Borislav Petkov wrote:
>> +			struct mce *entry = &mcelog.entry[i];
> 
> Just go ahead and call it m:
> 
> 			struct mce *m = ...
> 
> we know it's an mce struct.

Ah, fair enough.
Next version will use m.

Thanks,
H.Seto

