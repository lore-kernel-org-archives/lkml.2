Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2A0IPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:15:41 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45932 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2A0IPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:15:39 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CAOesGMghrFvCzyTaLfeF5RB77UUxpzEQj+j5Ega_uzL1SdbrOg@mail.gmail.com>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
	<1327594923-21822-2-git-send-email-pdeschrijver@nvidia.com>
	<CAOesGMghrFvCzyTaLfeF5RB77UUxpzEQj+j5Ega_uzL1SdbrOg@mail.gmail.com>
Date: Fri, 27 Jan 2012 00:15:37 -0800
Message-ID: <CAOesGMhaNybgVvLwT28MNjquRn6K55vRZPOiOyp1Ospg4_-uug@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] ARM: tegra: definitions for flow controller
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 6:17 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> On Thu, Jan 26, 2012 at 8:22 AM, Peter De Schrijver
> <pdeschrijver@nvidia.com> wrote:
>> Introduce some definitions for the tegra flow contoller. This will be
>> used by the code which controls entering and leaving LP3.
>>
>> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
>
> Do you expect to use these defines anywhere else than in the sleep.S
> in the near future? If not, please just move them over to that file.

I just looked at the Tegra30 secondary cores patch series, it's used there.

Please ignore.

-Olof
