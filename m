Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1A3IXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 03:23:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44201 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab1A3IXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 03:23:35 -0500
Date: Sun, 30 Jan 2011 17:23:43 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH 0/5] mmc: add double buffering for mmc block requests
In-reply-to: <AANLkTi=H71TQpuBnagMThcv-6NKJyqsD-xtg_eW8Pb_T@mail.gmail.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Chris Ball <cjb@laptop.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4D45200F.9090007@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
References: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
 <4D34FC5D.5080605@samsung.com>
 <AANLkTimjfO4Wb0f87X_sDugW=yU1=YEQn35uZnsKKwq2@mail.gmail.com>
 <AANLkTi=H71TQpuBnagMThcv-6NKJyqsD-xtg_eW8Pb_T@mail.gmail.com>
X-OriginalArrivalTime: 30 Jan 2011 08:23:27.0948 (UTC)
 FILETIME=[F88690C0:01CBC056]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Per.

If you sketch a implementation for sdhci. i can test the patches on the Samsung Soc
Your help is very nice for me :).i want to know how much improve the performance 
after applied your patch.

Regards,
Jaehoon Chung

Per Forlin wrote:
> Hi Jaehoon,
> 
> Have you had the chance to test the patches on the Samsung Soc. I can
> sketch a implementation for sdhci if that helps? Unfortunately I don't
> have any hardware to test the SDHCI driver unless there is support in
> QEMU?
> I really think I need to test this on more hardware in order to get
> more results for the patchset and hopefully more attention as well.
> 
> BR
> Per
> 
> On 18 January 2011 09:12, Per Forlin <per.forlin@linaro.org> wrote:
>> On 18 January 2011 03:35, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>> Hi Per..
>>>
>>> it is interesting approach..so
>>> we want to test your double buffering in our environment(Samsung SoC).
>>>
>>> Did you test with SDHCI?
>> So far I have only tested on mmci for board u5500 and u8500. I happily
>> test on a different board if I can get hold of one.
>>
>>> If you tested with SDHCI, i want to know how much increase the performance.
>>>
>>> Thanks,
>>> Jaehoon Chung
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

