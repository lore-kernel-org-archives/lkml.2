Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab2GLKhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:37:24 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16324 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607Ab2GLKhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:37:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Jul 2012 03:37:21 -0700
Message-ID: <4FFEA748.9080109@nvidia.com>
Date: Thu, 12 Jul 2012 16:00:32 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/5] i2c: tegra: convert normal suspend/resume to *_noirq
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com> <1341919244-23327-6-git-send-email-ldewangan@nvidia.com> <20120712103509.GF27520@pengutronix.de>
In-Reply-To: <20120712103509.GF27520@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2012 04:05 PM, Wolfram Sang wrote:
> * PGP Signed by an unknown key
>
> On Tue, Jul 10, 2012 at 04:50:44PM +0530, Laxman Dewangan wrote:
>> To provide the late suspend and early resume for i2c
>> driver, convert the suspend/resume as
>> 	suspend->  suspend_noirq
>> 	resume ->  resume_noirq
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> Applied to next on top of Rafael's patches. Please have a look if I did
> the fixup right.
Thanks for taking care.
Can you please point me your git path so that I can verify it?

Thanks,
Laxman
