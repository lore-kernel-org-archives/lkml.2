Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3ACXYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:24:08 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:55977 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3ACXYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:24:06 -0500
MIME-Version: 1.0
In-Reply-To: <50E610FD.8010307@zankel.net>
References: <1357151234-5681-1-git-send-email-swarren@wwwdotorg.org>
	<50E610FD.8010307@zankel.net>
Date: Fri, 4 Jan 2013 02:24:04 +0300
Message-ID: <CAMo8BfLVo5f1L-ugJ-1srM05vFjMgH6-on+odOk9mEpXx3X+pg@mail.gmail.com>
Subject: Re: [PATCH REPOST] xtensa: use new common dtc rule
From: Max Filippov <jcmvbkbc@gmail.com>
To: Chris Zankel <chris@zankel.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 3:15 AM, Chris Zankel <chris@zankel.net> wrote:
> Hi Stephen,
>
> Thanks for the patch. I have added it to the 'for_next' tree. Max, since you
> added that feature for Xtensa, any comments before I ask to pull?

No objections. In fact this resent version is almost identical to the one
queued on my xtensa-fixes-for-upstream branch:

https://github.com/jcmvbkbc/linux-xtensa/commit/2442a9c5df9ea9a2fd289fbd4e5de9a9810cab32

> On 1/2/13 7:27 PM, Stephen Warren wrote:
>>
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> The current rules have the .dtb files build in a different directory
>> from the .dts files. This patch changes xtensa to use the generic dtb
>> rule which builds .dtb files in the same directory as the source .dts.
>>
>> This requires moving parts of arch/xtensa/boot/Makefile into newly
>> created arch/xtensa/boot/dts/Makefile, and updating arch/xtensa/Makefile
>> to call the new Makefile.

-- 
Thanks.
-- Max
