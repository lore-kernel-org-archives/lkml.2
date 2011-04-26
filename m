Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1DZGE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:04:26 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:37231 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754783Ab1DZGEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:04:25 -0400
Message-ID: <4DB65EEC.7060604@ti.com>
Date: Tue, 26 Apr 2011 11:28:04 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Michael Bohan <mbohan@codeaurora.org>, mingo@elte.hu,
        akpm@linux-foundation.org, simon.kagstrom@netinsight.net,
        David.Woodhouse@intel.com, lethal@linux-sh.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: console_cpu_notify can cause scheduling BUG during CPU hotplug
References: <4DB604C7.8090305@codeaurora.org> <BANLkTimPHaiiiVC_A6jtUtaa_pYJuhepYg@mail.gmail.com>
In-Reply-To: <BANLkTimPHaiiiVC_A6jtUtaa_pYJuhepYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/2011 5:48 AM, Kevin Cernekee wrote:
> On Mon, Apr 25, 2011 at 4:33 PM, Michael Bohan<mbohan@codeaurora.org>  wrote:
>> I was curious if this scenario was accounted for in the design of the
>> console CPU notifier. One workaround for this problem is to remove CPU_DEAD
>> from the possible actions in console_cpu_notify(). In fact, v1-v4 of the
>> patch above did not have CPU_DEAD, CPU_DYING or CPU_DOWN_FAILED in the list
>> of actions. I wasn't able to track down why the other cases were added in
>> the final patch.
>
> Here is the background information on the CPU_{DEAD,DYING,DOWN_FAILED} cases:
>
> http://lkml.org/lkml/2010/6/29/65
That's right.
May be the change log for commit '034260d67' would have been
bit more descriptive about the CPU hot-plug events.

Regards
Santosh


