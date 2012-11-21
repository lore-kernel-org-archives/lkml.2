Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2KULzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:55:19 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61107 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2KULzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:55:14 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20121120103905.GA3908@polaris.bitmath.org>
References: <CA+55aFxdin9yatcyRkTqG--fdBS-KHh0eXnK5RmONw_uJe8sfQ@mail.gmail.com>
	<20121120103905.GA3908@polaris.bitmath.org>
Date: Wed, 21 Nov 2012 12:55:12 +0100
Message-ID: <CAKMK7uEemJg=h3aY2xfTRaEqC9t5ADgS2-FSasAvdC66zbz1Vw@mail.gmail.com>
Subject: Re: Linux 3.7-rc6
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Henrik Rydberg <rydberg@bitmath.se>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 11:39 AM, Henrik Rydberg <rydberg@bitmath.se> wrote:
>>       drm/i915: do not ignore eDP bpc settings from vbt
>
> As advertised, this patch breaks the Macbook Pro Retina, which seems
> unfair. The patch below is certainly not the best remedy, but it does
> work. Tested on a MacbookPro10,1.

My apologies for the long delay in answering, I've somehow mixed up
different bugreports and thought I've sent you a patch to test
already. Anyway, please test

https://patchwork.kernel.org/patch/1728111/

Thanks, Daniel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
