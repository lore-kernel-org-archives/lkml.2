Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2LKPb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:31:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab2LKPbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:31:25 -0500
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING: at drivers/gpu/drm/i915/i915_gem.c:3437 i915_gem_object_pin+0x151/0x1a0()
References: <87vcc8vkgn.fsf@redhat.com>
	<CAKMK7uHQFsrXX3FKoVA_AiA1iwo_-NRf_CqaqWXy9rNUg+tonQ@mail.gmail.com>
Date: Tue, 11 Dec 2012 16:31:09 +0100
In-Reply-To: <CAKMK7uHQFsrXX3FKoVA_AiA1iwo_-NRf_CqaqWXy9rNUg+tonQ@mail.gmail.com>
	(Daniel Vetter's message of "Tue, 11 Dec 2012 16:08:26 +0100")
Message-ID: <87r4mwvc5e.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Vetter <daniel.vetter@ffwll.ch> writes:

> On Tue, Dec 11, 2012 at 1:31 PM, Nikola Pajkovsky <npajkovs@redhat.com> wrote:
>> looks like we still have some oops in i915. i915 maintainers do you have
>> any ideas what's going on? I will try to trigger that oops later today
>> and provide more information.
>
> The infamous pin leak. Should be fixed with
>
> commit b4a98e57fc27854b5938fc8b08b68e5e68b91e1f
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Thu Nov 1 09:26:26 2012 +0000
>
>     drm/i915: Flush outstanding unpin tasks before pageflipping
>
> available from the drm-next (or linux-next) trees. If it holds up once
> merged, we'll backport it.

Thanks for the info, I will merge it into my local tree and give it try.

-- 
Nikola
