Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1HZWYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 18:24:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50861 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1HZWYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 18:24:46 -0400
Message-ID: <4E581D1A.90404@zytor.com>
Date: Fri, 26 Aug 2011 15:24:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Tony Vroon <tony@linx.net>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, yinghai@kernel.org
Subject: Re: MTRR setup failure on Fujitsu Lifebook S761
References: <4E579397.6010009@linx.net>  <4E57CBBB.3040806@zytor.com>  <1314385315.8356.0.camel@localhost> <1314394157.4729.23.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1314394157.4729.23.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 02:29 PM, Suresh Siddha wrote:
> On Fri, 2011-08-26 at 12:01 -0700, Tony Vroon wrote:
>> On Fri, 2011-08-26 at 09:37 -0700, H. Peter Anvin wrote:
>>> Hm, I don't see any evidence of the MTRR sanitizer running at all...
>>
>> It is almost as if it failed to find an optimal configuration; does that
>> error path not print anything?
> 
> MTRR cleanup bails out in mtrr_need_cleanup() if it finds any entry
> other than WB or UC. And the first entry you had was write-protect.

WP for the BIOS is becoming reasonably common; we need to handle that.

	-hpa

