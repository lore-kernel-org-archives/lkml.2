Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1JSQr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:47:29 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:42561 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213Ab1JSQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:47:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAOLZvyFoiuHEfpnozWpAM5h92rjay-asqXX0tY1P1ZzO8eTGOQ@mail.gmail.com>
References: <1318909555-12933-3-git-send-email-julia@diku.dk>
	<CAOLZvyFoiuHEfpnozWpAM5h92rjay-asqXX0tY1P1ZzO8eTGOQ@mail.gmail.com>
Date: Wed, 19 Oct 2011 17:47:25 +0100
Message-ID: <CABS+qY2pBkNjHUKrtD3QttQOQD-LpStHopSGxzeG-iyc7RtVgw@mail.gmail.com>
Subject: Re: [PATCH 3/3] sound/soc/au1x: keep pointer to resource so it can be freed
From: "Girdwood, Liam" <lrg@ti.com>
To: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Axel Lin <axel.lin@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 October 2011 15:50, Manuel Lauss <manuel.lauss@googlemail.com> wrote:
> On Tue, Oct 18, 2011 at 5:45 AM, Julia Lawall <julia@diku.dk> wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> Add a new variable for storing resources accessed subsequent to the one
>> accessed using request_mem_region, so the one accessed using
>> request_mem_region can be released if needed.
>>
>> This code is also missing some calls to iounmap.
>
> How about something much simpler, like this:
>
> From 940e38b3f0beff6fcd8f62f627dce622e9ca0e54 Mon Sep 17 00:00:00 2001
> From: Manuel Lauss <manuel.lauss@googlemail.com>
> Date: Wed, 19 Oct 2011 16:45:12 +0200
> Subject: [PATCH] ASoC: au1x: fix error paths in ac97c/i2cs probe callbacks.
>
> add iounmap() and release the correct mem resource.
>
> Signed-off-by: Manuel Lauss <manuel.lauss@googlemail.com>

Acked-by: Liam Girdwood <lrg@ti.com>
