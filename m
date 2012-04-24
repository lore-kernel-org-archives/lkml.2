Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2DXHmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:42:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53452 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab2DXHmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:42:35 -0400
MIME-Version: 1.0
In-Reply-To: <4F8FD709.60308@nvidia.com>
References: <1334645155-13799-1-git-send-email-ldewangan@nvidia.com>
	<1334645155-13799-4-git-send-email-ldewangan@nvidia.com>
	<4F8DF01D.9040900@wwwdotorg.org>
	<4F8FD709.60308@nvidia.com>
Date: Tue, 24 Apr 2012 09:42:35 +0200
Message-ID: <CACRpkdY5_F91oxzTScoBehABDHZBgZy1HkDK1okUq2uTLHh=Mg@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: dt: tegra_ventana: als and proximity sensor
 isl29018 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, "olof@lixom.net" <olof@lixom.net>,
        Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 11:12 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> On Wednesday 18 April 2012 04:05 AM, Stephen Warren wrote:
>>
>> On 04/17/2012 12:45 AM, Laxman Dewangan wrote:
>>>
>>> Add the device info for ALS and proximity sensor isl29018.
>>
>>
>> a) Perhaps the vendor prefix should be "isil" not "isl". Olof, can you
>> please comment here?
>>
>
> Any comments on this? I think "isil" is good as it is the symbol in nasdaq
> also: Intersil Corporation (ISIL).
> If no objection than I can send my next version of patch ;)
>
> Adding LinusW, Mark and Grant if they have any comment here.

Like most of the kernel people I don't care much about that as long
as the string is unique ... your pick is likely the best.

Linus Walleij
