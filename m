Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab0GTHyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:54:36 -0400
Received: from compulab.co.il ([67.18.134.219]:50540 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab0GTHye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:54:34 -0400
Message-ID: <4C455614.1000801@compulab.co.il>
Date: Tue, 20 Jul 2010 10:53:56 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Kulikov Vasiliy <segooon@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Erik Gilling <konkers@android.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/8] arm/mach-tegra: fix unsigned calcs
References: <1279219395-12088-1-git-send-email-segooon@gmail.com> <AANLkTinFKH4Ed3UW3kMKdT5RJwmmE5n5k7nO01mB9xpO@mail.gmail.com>
In-Reply-To: <AANLkTinFKH4Ed3UW3kMKdT5RJwmmE5n5k7nO01mB9xpO@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Cross wrote:
> On Thu, Jul 15, 2010 at 11:43 AM, Kulikov Vasiliy <segooon@gmail.com> wrote:
>> divider_u71 is unsigned, so this check is buggy:
>> if (divider_u71 - 2 > 255 || divider_u71 - 2 < 0)
>>
>> If divider_u71 is 0 or 1 both checks are lying.
>> So, it does not produce a buggy answer, but it is confusing.
> 
> Hi Kulikov,

The first name is Vasiliy :)

> Thanks for the patch.  This problem has been fixed in another patch in
> the linux-tegra tree, I'll post it for review and update the
> linux-next tree soon.
> 
> Colin Cross
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


-- 
Sincerely yours,
Mike.
