Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1AMEkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 23:40:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027Ab1AMEkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 23:40:51 -0500
MIME-Version: 1.0
In-Reply-To: <b7da2f$q4ct63@fmsmga001.fm.intel.com>
References: <1294877597-17843-1-git-send-email-chris@chris-wilson.co.uk>
 <AANLkTi=qHW3esgZYq55dgSz15ZDpukXn6zO17nJ1fWzS@mail.gmail.com> <b7da2f$q4ct63@fmsmga001.fm.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Jan 2011 20:39:54 -0800
Message-ID: <AANLkTinBnm+xkXPPM4-3PG_i2hJMuXhv8x42KN4o3kGg@mail.gmail.com>
Subject: Re: [PATCH] drm/i915/execbuffer: Reorder relocations to match new
 object order
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 4:48 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 12 Jan 2011 16:27:46 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> I think you're still missing some case.
>>
>> This improves the video case a lot - I can't see any artifacts there -
>> but I still get occasional corruption when moving between the "share"
>> and "rate" buttons, and they end up drawing incorrectly.
>
> Now we're probably drifting into other bug territory... ;-)
>
> I'll look again in the morning. Usually running the conformance test
> suites in parallel is enough to exercise the worst-case behaviour.

I'm pretty dang sure it's still the same bug.

I went back to the revert, and tried very hard, but I cannot reproduce
even a whiff of the corruption with the revert. No corruption
what-so-ever.

With your patch, the corruption is _less_, but it's absolutely there.
So the re-ordering of the object list is doing something else too.

                   Linus
