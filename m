Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1HBJAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:00:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15937 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1HBJAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:00:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6425"; a="107486309"
Message-ID: <4E37BCA2.4010208@codeaurora.org>
Date: Tue, 02 Aug 2011 14:30:18 +0530
From: Anirudh Ghayal <aghayal@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Amy Maloche <amaloche@codeaurora.org>
Subject: Re: [PATCH] input: misc: Add support for pm8xxx based vibrator driver
References: <1312258397-11039-1-git-send-email-aghayal@codeaurora.org> <CAM=Q2cvzsZO4dc6Ot_aYJyLW27TErgySdXRcHr1UDb5ua1uHAg@mail.gmail.com> <4E3798C1.3080800@codeaurora.org> <20110802064124.GA21319@core.coreip.homeip.net>
In-Reply-To: <20110802064124.GA21319@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 8/2/2011 12:11 PM, Dmitry Torokhov wrote:
> On Tue, Aug 02, 2011 at 11:57:13AM +0530, Anirudh Ghayal wrote:
>
>> Yes should have been dev_err.
>>
>> Dmitry, would you like me to submit another patch for this? I can
>> make the @work change as well. Or would you make this minor change
>> as well. Thank you.
>>
>
> Anirudh, I made this plus a few more cosmetic changes, if you could try
> the patch below and let me know if it still works I will commit it for
> the next merge window.
>

Thank you for making changes. I have tested the patch and it works fine.

Thank you,
~Anirudh

> Thanks.
>


