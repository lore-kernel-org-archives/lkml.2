Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab2ASScv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 13:32:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55950 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab2ASSct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 13:32:49 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB0F3@HQMAIL01.nvidia.com>
References: <1325882311-7504-1-git-send-email-swarren@nvidia.com>
	<CACRpkdY+qpm1na_fdSEiSeBPQNFYf4JTapVE5o6m07OQiaoPCw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1780DAB0F3@HQMAIL01.nvidia.com>
Date: Thu, 19 Jan 2012 19:32:49 +0100
Message-ID: <CACRpkdYen==qdQMidskw5V6Q1=r-4hOv0K4OW4qkxwnBv+L-QA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Fix pinconf_pins_show iteration
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chanho Park <chanho61.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 6:52 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Tuesday, January 10, 2012 2:17 AM:
>> On Fri, Jan 6, 2012 at 9:38 PM, Stephen Warren <swarren@nvidia.com> wrote:
>>
>> > Commit 706e852 "pinctrl: correct a offset while enumerating pins"
>> > modified the variable used by pinconf_pin_show()'s for loop, but didn't
>> > update the for loop test expression.
>> >
>> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>
>> OK applied to my fixes branch, will send this along with any other
>> fixes once Torvalds has pulled the pinctrl tree for this merge window.
>
> Linus,
>
> This still hasn't shown up in next-20120119. Is that expected?

Yes I was waiting for the merge window to close, but I guess that's
a bit over-cautios. I'll push it out tomorrow...

Thanks,
Linus Walleij
