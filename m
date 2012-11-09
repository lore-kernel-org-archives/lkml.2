Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab2KIQEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:04:14 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59312 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab2KIQEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:04:10 -0500
MIME-Version: 1.0
In-Reply-To: <509D28B6.3060207@vodafone.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
	<1352469579-3337-3-git-send-email-thierry.reding@avionic-design.de>
	<CACna6rycZ=TGHP7KpVa_r0JSpc6c=PB89pijR9E_4A=bQ=74Bw@mail.gmail.com>
	<509D28B6.3060207@vodafone.de>
Date: Fri, 9 Nov 2012 17:04:09 +0100
Message-ID: <CACna6rxOBENLVC8mgJdsSdAZdWranMiivSgq_8DzeTo0hzzWqg@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm: tegra: Add HDMI support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-tegra@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/9 Christian König <deathsimple@vodafone.de>:
> On 09.11.2012 16:45, Rafał Miłecki wrote:
>> I was told it won't work on different endian devices. See
>> [RFC][PATCH] drm/radeon/hdmi: define struct for AVI infoframe
>> http://lists.freedesktop.org/archives/dri-devel/2012-May/022544.html
>
>
> Yeah, that's indeed true. And honestly adding just another implementation of
> the HDMI info frames sounds like somebody should finally sit down and
> implement it in a common drm_hdmi.c

Agree.

-- 
Rafał
