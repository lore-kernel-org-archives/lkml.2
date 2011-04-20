Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1DTSCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:02:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15956 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1DTSCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:02:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6322"; a="86935916"
Message-ID: <143ea9b1bb96e613d534caa7cb3a1e2d.squirrel@www.codeaurora.org>
In-Reply-To: <BANLkTin_TpzdQS96SPKUNye6vb2b55Qc4A@mail.gmail.com>
References: <1302822031-6752-1-git-send-email-sjg@chromium.org>
    <4DA7A914.5020804@codeaurora.org>
    <BANLkTikcY-xzjd0W77UfWWoO8ibjKNXQGg@mail.gmail.com>
    <BANLkTin_TpzdQS96SPKUNye6vb2b55Qc4A@mail.gmail.com>
Date: Wed, 20 Apr 2011 11:01:59 -0700 (PDT)
Subject: Re: [PATCH v4] ARM: Use generic BUG() handler
From: "Stephen Boyd" <sboyd@codeaurora.org>
To: "anish singh" <anish198519851985@gmail.com>
Cc: "Simon Glass" <sjg@chromium.org>, linux-arm-kernel@lists.infradead.org,
        "Russell King" <linux@arm.linux.org.uk>,
        "Tony Lindgren" <tony@atomide.com>,
        "Nicolas Pitre" <nicolas.pitre@linaro.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Joe Perches" <joe@perches.com>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Alexander Shishkin" <virtuoso@slind.org>,
        "Phil Carmody" <ext-phil.2.carmody@nokia.com>,
        "Rabin Vincent" <rabin@rab.in>, linux-kernel@vger.kernel.org,
        "Omar Ramirez Luna" <omar.ramirez@ti.com>,
        "Dave Martin" <dave.martin@linaro.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Apr 20, 2011 at 8:10 AM, Simon Glass <sjg@chromium.org> wrote:
>
>> On Thu, Apr 14, 2011 at 7:10 PM, Stephen Boyd <sboyd@codeaurora.org>
>> wrote:
>> > On 04/14/2011 04:00 PM, Simon Glass wrote:
>> >> From: Simon Glass <sjg@google.com>
>> >>
>> >> ARM uses its own BUG() handler which makes its output slightly
>> different
>> >> from other archtectures.
>>
>>
>> >> Signed-off-by: Simon Glass <sjg@chromium.org>
>> >
>> > Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
>>
>> Thanks Stephen. Since there were no other comments I have submitted
>> this to RMK's patch tracking system.
>>
>
> Will this be part of linux kernel as i am not aware of patch tracking
> system? I want to back port this feature on my
> board which has Linux 2.6.35.7 kernel version(android gingerbread).
>

It's here:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6885/1

I imagine it will be added when/if Russell picks it up. Sadly it
increases the LOC in ARM so Simon might need to really
sell it to get it merged.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

