Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1BCXTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:19:10 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45435 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab1BCXTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:19:08 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="73119861"
Message-ID: <4D4B37EB.7070401@codeaurora.org>
Date: Thu, 03 Feb 2011 15:19:07 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Boyd <sboyd@codeaurora.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] hvc_dcc cleanups and fixes
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>    <1292875718-7980-1-git-send-email-sboyd@codeaurora.org>    <20110203221742.GA4159@kroah.com>
In-Reply-To: <20110203221742.GA4159@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 20, 2010 at 12:08:35PM -0800, Stephen Boyd wrote:
>> Here are the split patches.
>>
>> The first two patches cleanup and fix the hvc_dcc driver for my
>> compiler. The final patch is more controversial, it removes the
>> v6 and v7 differences in this driver.
>>
>> Stephen Boyd (3):
>>   hvc_dcc: Fix bad code generation by marking assembly volatile
>>   hvc_dcc: Simplify put_chars()/get_chars() loops
>>   hvc_dcc: Simplify assembly for v6 and v7 ARM
> 
> Can you redo these against the linux-next tree as they don't apply
> anymore and resend them so I can apply them?
> 

Have you tried 'git am -3' on them? I assume it's the movement of the
file that's causing the problem.

Either way, I'll resend and collect the acks in a bit.
