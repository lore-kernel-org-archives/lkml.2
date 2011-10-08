Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1JHNZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 09:25:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52448 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1JHNZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 09:25:47 -0400
MIME-Version: 1.0
In-Reply-To: <4E8F6532.9060609@gmail.com>
References: <01e601cc84d9$4530d6a0$cf9283e0$%kim@samsung.com>
	<4E8F6532.9060609@gmail.com>
Date: Sat, 8 Oct 2011 22:25:45 +0900
X-Google-Sender-Auth: ydDtYInbSfLdOLsDyH30XYU3bVk
Message-ID: <CAHQjnOPRvjD1X-T3w1yDKhf5QLq9rz9Vc2vs2yzU1xynFx-Wow@mail.gmail.com>
Subject: Re: [PATCH v3 RE-SEND 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>, joerg.roedel@amd.com,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        younglak1004.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 5:46 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
>> -
>> -config S5P_SLEEP
>> -     bool
>> -     help
>> -       Internal config node to apply common S5P sleep management code.
>> -       Can be selected by S5P and newer SoCs with similar sleep procedure.
>> -
>
> Is S5P_SLEEP being removed intentionally ? It doesn't seem to belong here.

No, it is a mistake while rebasing the patches.

Thank you for pointing that.
