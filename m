Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1BTLTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 06:19:19 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:36542 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab1BTLTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 06:19:18 -0500
Message-ID: <b51c68e52b0495f1c354f200bc50c7ec.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110220105514.GB3514@viiv.ffwll.ch>
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
    <20110219182511.GA3977@viiv.ffwll.ch>
    <92f5b87a3559ed7f1b7c46b7497c1ad5.squirrel@webmail.greenhost.nl>
    <20110220105514.GB3514@viiv.ffwll.ch>
Date: Sun, 20 Feb 2011 12:19:14 +0100 (CET)
Subject: Re: [BUG] drm/i915 Screen corruption introduced by 
     a00b10c360b35d6431a94cb
From: "Indan Zupancic" <indan@nul.nu>
To: "Daniel Vetter" <daniel@ffwll.ch>
Cc: "Indan Zupancic" <indan@nul.nu>, "Chris Wilson" <chris@chris-wilson.co.uk>,
        "LKML" <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: a350ae07b5350cdad28cef237d2e7179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Good news:

On Sun, February 20, 2011 11:55, Daniel Vetter wrote:
>> > I've created two quick patches to check a few theories, please test them
>> > (both patches independently and both together). Patches attached.
>>
>> Tried with both applied, doesn't change anything.
>
> I've just noticed that one of the patches (the 2nd one) doesn't work as
> advertised. Please retest with the attached one.

This one fixes it!

So ignore my other email, you nailed it. Thanks a heap Daniel.

Tomorrow I'll test more and double check, but it seems fixed.

Of course, looking at the patch, I guess it isn't generally
applicable, so perhaps either more digging or a special
exception for older chipsets is needed. I'm happy to test
any further patches if that helps, triggering the corruption
is really easy for me.

Thanks,

Indan


