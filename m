Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1A1I2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:28:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56008 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab1A1I2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:28:50 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimjfO4Wb0f87X_sDugW=yU1=YEQn35uZnsKKwq2@mail.gmail.com>
References: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
	<4D34FC5D.5080605@samsung.com>
	<AANLkTimjfO4Wb0f87X_sDugW=yU1=YEQn35uZnsKKwq2@mail.gmail.com>
Date: Fri, 28 Jan 2011 09:28:48 +0100
Message-ID: <AANLkTi=H71TQpuBnagMThcv-6NKJyqsD-xtg_eW8Pb_T@mail.gmail.com>
Subject: Re: [PATCH 0/5] mmc: add double buffering for mmc block requests
From: Per Forlin <per.forlin@linaro.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Chris Ball <cjb@laptop.org>, Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaehoon,

Have you had the chance to test the patches on the Samsung Soc. I can
sketch a implementation for sdhci if that helps? Unfortunately I don't
have any hardware to test the SDHCI driver unless there is support in
QEMU?
I really think I need to test this on more hardware in order to get
more results for the patchset and hopefully more attention as well.

BR
Per

On 18 January 2011 09:12, Per Forlin <per.forlin@linaro.org> wrote:
> On 18 January 2011 03:35, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> Hi Per..
>>
>> it is interesting approach..so
>> we want to test your double buffering in our environment(Samsung SoC).
>>
>> Did you test with SDHCI?
> So far I have only tested on mmci for board u5500 and u8500. I happily
> test on a different board if I can get hold of one.
>
>> If you tested with SDHCI, i want to know how much increase the performance.
>>
>> Thanks,
>> Jaehoon Chung
>
