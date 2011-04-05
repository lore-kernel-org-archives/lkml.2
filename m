Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1DETpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:45:51 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35553 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1DETpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:45:47 -0400
Message-ID: <4D9B7164.5070309@canonical.com>
Date: Tue, 05 Apr 2011 15:45:40 -0400
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Thunderbird/3.1.9
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jeffrey Brown <jeffbrown@android.com>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>, Simon Budig <simon@budig.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] hid-magicmouse: Increase evdev buffer size
References: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com> <AANLkTim-tN=siA8tJVCzNZHs+oM0hN-N8Ckc+9ynnNpb@mail.gmail.com> <alpine.LNX.2.00.1104041441530.28516@pobox.suse.cz> <BANLkTikG-ku9mDebcaPKTwv3X0N+OKiyYQ@mail.gmail.com> <4D9A1407.6030308@canonical.com> <20110404213910.GD984@core.coreip.homeip.net>
In-Reply-To: <20110404213910.GD984@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 05:39 PM, Dmitry Torokhov wrote:
> On Mon, Apr 04, 2011 at 02:55:03PM -0400, Chase Douglas wrote:
>> On 04/04/2011 02:13 PM, Jeffrey Brown wrote:
>>> On Mon, Apr 4, 2011 at 5:43 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>>>> I'd happuly take Chase's patch, but want to make sure that we don't cause
>>>> any changes that would make backwards compatilibity an issue later.
>>>
>>> There should be no compatibility issues.  However, we might be better
>>> off in the long term taking (some variation of) these patches instead.
>>
>> I like the proposed changes, but I want to ensure stable kernel releases
>> aren't left out of the fix for hid-magicmouse. I don't know the best way
>> forward, but here's one possibility:
>>
>> 1. Apply my patch to manually set the buffer size hint
>> 2. It gets sent to stable trees due to the 'Cc: stable@kernel.org' line
>> 3. Apply Jeffrey's patches, including a reversion of my buffer size hint
>>
>> Obviously the extra application and reversion is odd, but this seems the
>> easiest way forward given that the patches already exist and can be
>> applied without issue.
>>
> 
> Or, once Jeffrey's patches hit mainline, send your change to stable with
> the explanation why it is needed for stable but not for mainline.

One thing that crossed my mind is that Jeffrey's patches wouldn't be
merged until 2.6.40, right? If so, even 2.6.39 will be released with
this bug, which makes me want to go with the plan I outlined above.

Thanks,

-- Chase
