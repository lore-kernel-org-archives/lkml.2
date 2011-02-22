Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab1BVDj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:39:58 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:59094 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1BVDj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:39:57 -0500
Message-ID: <96f4040e154c151ce996b4afdaf42d5f.squirrel@webmail.greenhost.nl>
In-Reply-To: <8a955ec5ebee88511413424fdcaf85c4.squirrel@webmail.greenhost.nl>
References: <8a955ec5ebee88511413424fdcaf85c4.squirrel@webmail.greenhost.nl>
Date: Tue, 22 Feb 2011 04:39:55 +0100 (CET)
Subject: Re: [BUG] drm/i915 Screen corruption introduced by      
     a00b10c360b35d6431a94cb
From: "Indan Zupancic" <indan@nul.nu>
To: "Indan Zupancic" <indan@nul.nu>
Cc: "Chris Wilson" <chris@chris-wilson.co.uk>,
        "LKML" <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 2ecd0b53b7de9511489f92806276a3d7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, February 22, 2011 04:25, Indan Zupancic wrote:
> Hi,
>
> On Sun, February 20, 2011 14:21, Daniel Vetter wrote:
>> Well, don't start jumping around, yet. These patches are just to rule out
>> some theories. Now: Is it fixed with just the 2nd patch alone or do you need both
>> patches? This is very important, so please test extensively whether there are really
>> no corruptions with just the 2nd patch.
>
> I managed to create some corruption with an xterm above xpdf. It looks  different
> than the original corruption, so I think it's safe to say it's a different bug:
>
> http://img593.imageshack.us/i/ss1298340823.png
> http://img203.imageshack.us/i/ss1298340776.png
>
> This was without xcompmgr running, I don't think I would have seen it otherwise.
> Actually, it turns out it's really easy to trigger as well, so I can more easily
> test patches now. Unfortunately I wasn't smart enough to store the bisecting kernels,
> gah!
>
> I tried with both your patches, as well as the HIC poking patch, but I still get it.
>
> I'll try to pinpoint more exactly when this started to happen.

Okay, I tried older kernels and I get it even with 2.6.34, so I think it's a bug
in userspace, like intel-dri, or perhaps the intel X driver (though I get the same
with an older version).

Greetings,

Indan


