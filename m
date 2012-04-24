Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2DXFmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 01:42:12 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:47710 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889Ab2DXFmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 01:42:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120423204509.587bf0b2@wker>
References: <1335114510-29413-1-git-send-email-agust@denx.de>
	<CAP05o4JpwtERvLRitBKztrcr_9N+Kxm+SgU=yptUu9VfL3avkg@mail.gmail.com>
	<20120423204509.587bf0b2@wker>
Date: Tue, 24 Apr 2012 11:12:09 +0530
Message-ID: <CAP05o4Jg4F-rFVQVZpUe3RiYRgVx6SjpKAPvEJZrjc323GoEgA@mail.gmail.com>
Subject: Re: [PATCH] mfd: omap-ush-host: Fix build breakage
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 12:15 AM, Anatolij Gustschin <agust@denx.de> wrote:
> On Mon, 23 Apr 2012 11:47:25 +0530
> "Munegowda, Keshava" <keshava_mgowda@ti.com> wrote:
> ...
>> Yes, this seems correct!
>> But, on which config you are seeing this error?
>
> I was working on some drivers for am3517 based board and I'm seeing
> this error since I rebased by patches on v3.4-rc4.
>
> Thanks,
> Anatolij

Thanks Anatoliji
        yes, I dont have am3517 setup; I have validated this patch on
omap3 sdp and omap4 sdp

regards
keshava
