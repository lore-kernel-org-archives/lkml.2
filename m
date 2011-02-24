Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1BXJTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:19:07 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:59426 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab1BXJTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:19:04 -0500
Message-ID: <b5f94200cffe31ff8cbe38d2bd2e35a7.squirrel@webmail.greenhost.nl>
In-Reply-To: <AANLkTi=DXg=ighnPi4FYA29=qegE=c_PtCVWzOymYtmQ@mail.gmail.com>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
    <AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
    <0d30dc$l7ehaa@orsmga001.jf.intel.com>
    <AANLkTi=DXg=ighnPi4FYA29=qegE=c_PtCVWzOymYtmQ@mail.gmail.com>
Date: Thu, 24 Feb 2011 10:18:44 +0100 (CET)
Subject: Re: [git pull] drm fixes
From: "Indan Zupancic" <indan@nul.nu>
To: "Alex Riesen" <raa.lkml@gmail.com>
Cc: "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Dave Airlie" <airlied@linux.ie>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, "Daniel Vetter" <daniel@ffwll.ch>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 938925967a2432a0d8c7279c30be63be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 24, 2011 09:27, Alex Riesen wrote:
> On Thu, Feb 24, 2011 at 01:13, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Wed, 23 Feb 2011 15:58:02 -0800, Linus Torvalds <torvalds@linux-foundation.org>
>> wrote:
>>> >
>>> > See bug https://bugzilla.kernel.org/show_bug.cgi?id=27572
>>>
>>> Any update on that one?
>>
>> No, reverting that will cause just another bug elsewhere. I need to
>> work out how the gpu is not being flushed with a non-pipelined fence
>> change.
>>
>>> There's that whole "return -EINVAL for
>>> I915_PARAM_HAS_RELAXED_FENCING" patch thing?
>>
>> As it turns out this is a bug in the userspace components of the stack for
>> gen2 hardware, with lax kernel side enforcement. Daniel has a fix for both.
>
> Chris, could you point us at the patch? I ask because Daniel left a
> comment in bug discussion that we should ignore some patch from him,
> and there was no mention of anything else.
>
> I'll gladly test a better fix.

See:

http://lists.freedesktop.org/archives/dri-devel/2011-February/008658.html
https://lkml.org/lkml/2011/2/23/34


