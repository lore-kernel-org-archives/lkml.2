Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab1AYAUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:20:18 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10994 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1AYAUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:20:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71613297"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 01/11] msm: Add CPU queries
In-Reply-To: <1295914163.29639.77.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Mon, 24 Jan 2011 16:09:23 -0800")
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	<1295468747-22796-2-git-send-email-davidb@codeaurora.org>
	<1295914163.29639.77.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110125:linux-kernel@vger.kernel.org::gcDMXZOeycFTnVAV:0000000000000000000000000000000002NpW
X-Hashcash: 1:20:110125:linux-arm-msm@vger.kernel.org::TAkRG1+JtrU3inZO:000000000000000000000000000000003Yrc
X-Hashcash: 1:20:110125:dwalker@codeaurora.org::acV694HS3nC/Tl/C:0000000000000000000000000000000000000007c+R
X-Hashcash: 1:20:110125:linux-arm-kernel@lists.infradead.org::Y7+KAMjwxQt2ZVvV:00000000000000000000000008TcS
Date: Mon, 24 Jan 2011 16:20:16 -0800
Message-ID: <8yak4htj0lb.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24 2011, Daniel Walker wrote:

> On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
>> +#define cpu_is_msm7x01()       0
>> +#define cpu_is_msm7x30()       0
>> +#define cpu_is_qsd8x50()       0
>> +#define cpu_is_msm8x60()       0
>
> Now that I look at this again, why not drop the "x" all together ?

That might be better for the 8x60.  The complexity is that most of the
MSM chips have some variants, where the CPU running Linux isn't changed,
but the modem CPU is different (think CDMA/UMTS).  Until 8960, that was
distinguished by the second letter.

Either way doesn't quite match reality, unfortunately.  There are
devices using a MSM7201 and others using a MSM7601.  As far as Linux is
concerned, there isn't any difference between them.  If someone wanted
to try and identify the device they have with the code, it could be
confusing for either name chosen.

I was planning on turning msm8x60 into msm8660, since that seems to be
the most common one.  Perhaps the decoder ring should be put into the
help text for the options so people can at least figure out which is
which.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
