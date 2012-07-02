Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2GBTGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:06:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47038 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2GBTGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:06:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6760"; a="206813320"
Message-ID: <4FF1F145.2050408@codeaurora.org>
Date: Mon, 02 Jul 2012 12:06:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: Re: [PATCH 1/2] remoteproc: maintain a generic child device for each
 rproc
References: <1338017791-9442-1-git-send-email-ohad@wizery.com> <4FC5DBFA.2030300@codeaurora.org> <CAK=WgbZJJJPuNWVv8WgL=KKm6Hrx2krDD9gBOTP7sA8p7mh_rA@mail.gmail.com> <CAK=WgbbREXV8nkF4vh9iLUp1WQj2ZLYW6VG8Urmw9=roy63meQ@mail.gmail.com>
In-Reply-To: <CAK=WgbbREXV8nkF4vh9iLUp1WQj2ZLYW6VG8Urmw9=roy63meQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/12 01:13, Ohad Ben-Cohen wrote:
> On Wed, May 30, 2012 at 3:16 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> In this case, I was more wondering between using a class to a device type.
>>
>>> I recall seeing a thread where
>>> someone said classes were on the way out and shouldn't be used but I
>>> can't find it anymore.
>> I also remembered a similar discussion at a plumbers mini-conf about
>> 2-3 years ago too, so I looked at device_type as an alternative to
>> class. The former looks somewhat simpler, but I couldn't find any
>> major advantage for using one over the other, and both seem to be in
>> use by many subsystems.
> Moving to device_type is so trivial that I gave it a spin (and moved
> to IDA too while at it):

Great! It looks like device_type doesn't have any list iteration support
though. Is that requirement gone? If that requirement is still there I
would think we need something like a class or bus still.

Will you resend this as part of a series? It will be easier to review then.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

