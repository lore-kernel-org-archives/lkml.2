Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2CRHZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 03:25:14 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:38146 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890Ab2CRHZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 03:25:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRQDdXcKVp-_RNe-0i7YYLr4vKDDXqVw_eP4VsmfbFNtYg@mail.gmail.com>
References: <1331749794-8056-1-git-send-email-ccross@android.com>
 <1331749794-8056-4-git-send-email-ccross@android.com> <4F6483BA.8050103@ti.com>
 <CAMbhsRQDdXcKVp-_RNe-0i7YYLr4vKDDXqVw_eP4VsmfbFNtYg@mail.gmail.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Sun, 18 Mar 2012 12:48:22 +0530
Message-ID: <CAMQu2gz11nwDy2nzFDTL7XaLcf4ULqUDWVOEzAQLD9JJ8Y=JYA@mail.gmail.com>
Subject: Re: [PATCHv2 3/5] cpuidle: add support for states that affect
 multiple cpus
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 12:51 AM, Colin Cross <ccross@android.com> wrote:
> On Sat, Mar 17, 2012 at 5:29 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>
> <snip>
>
>> While playing around with this version, I noticed that the
>> 'alive_count' is ever incrementing which will lead to
>> coupled idle state not being attempted after one CPU offline
>> attempt.
>>
>> Fix in end of the email for the same. With it, coupled states
>> continue to work with CPU online/offline transitions.
>>
>> Feel free to fold it into original patch. Attached
>> the same in case mailer eat tabs.
>
> <snip>
>
> Thanks, Kevin reported this issue and I'll fix it in the next version.
 Ahh... I see comments from Kevin now. Some how I missed it
otherwise would have saved me few minutes of debug.

Regards
Santosh
