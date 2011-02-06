Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1BFGL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 01:11:57 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42969 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1BFGL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 01:11:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :face:mime-version:content-type:content-transfer-encoding;
        b=mFeQDggrjYZ63RUHw/OuUr+7hsqOP6O+jgujEVXBHIRNGS/sRdpaSCwnyQmtOlJeWZ
         zbFpPLOhRlHJlW98xs65ik6ZHmlEWP7OzK4x/S9Dm8NnwCZvBIxMq3TN6RTRKQq6OdhE
         6DKqi+vjoxR1V5vT7YliGdEmWmzisLEYcyMyY=
Date: Sun, 6 Feb 2011 00:11:47 -0600
From: Bobby Bingham <uhmmmm@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reverse-engineer safe snb wm0 values
Message-ID: <20110206001147.516daae4@duality>
In-Reply-To: <1296810777-16645-1-git-send-email-chris@chris-wilson.co.uk>
References: <20110203221108.281c8512@duality>
	<1296810777-16645-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAABhQTFRFCgYMLBEpThdDgTVgc1Jl3XeZ36FM2bm4ve5MKQAAAmtJREFUOMtVk01z2yAQhsFVJldA6uQagXOPhXU3zto6pzLtD6hHuSYzcvj7fRcUu9mxvvbZdz8ACyWEjLixyTbf7SM/Aq74XICwHLHqMhjVf8Cwy7oM4qZc2VYWt87m9zjuRAwLEAheuQIOsb4pBOrWpQQkv1R8FbdcNncghbgbHw9FIRlILqHbIJ6RqC9AtxrxEBi7ViK+3vkFCGdbAIaYNMbNWG/K6NJaY1tjuw4ffYy9M7me0RrBuDr+rGto+O0ljn4PYJ1dlqzuO6fET/i9X1tb2sVIXYuK6keMY++d7wDKOjgHrdWHnkEfPQLtooC/NeyL3o3d2nZFUnvuBGDsUCWiPrIxYH+rLYCPmxC3ZPdd2RYGxvb96KKnHsCtDfeLOa1uvesjg6ct7bGDnMv4diPbJxQ3cX06bImc2/FK+I1X0jrPippe/AG5gkSRsd/h2GDoWKMyK/ZoF4D3W5rOb+L2UBObafdCl3MldKe3AAjHT5vrERC6duj075YFRymfryDBLn46nonmo17tvvxVGmi+jNM0nYgmIdVVUQ0pDXuAt8vnJCpxsyp9pvk4TZ8pncU3u0cV+n0+zUTv38DQINv5DxRp9w2k8JAW+xqhtKBQBnaa0/vi0wsRBP/cBK7Q8HJIrXUGYUjD8YVbbZRQ5fy1LAqBPoa3HKIrBjjjLKmQUw0fnEMpaIQ2ps0gBB0oD6sUoWWNMwJeEcl7RUyU1PxoS/EhET1QBkE2TW6XAQ9BA9aDx9b5LjLgpUoEVRBSSiqj8YgZzMNlJsSH62pJlMgSmK4kXf1fABuJ4fRtA6VaQKJGqxD4H/8PjSueXT5olWEAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Feb 2011 09:12:57 +0000
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> ---
> Hi Bobby,
> 
> this is a patch that I am testing, but so far no else one has experienced
> the same symptoms that this fixes on my machines...
> 
> It looks like you have won the privilege of being my first victim^W
> tester.
> 
> Also in drm-intel-fixes
> (git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git)
> is a patch to invalidate the TLB on the BLT which also may cause hangs,
> but has a different pattern of failure in
> /sys/kernel/debug/dri/0/i915_error_state:
> 
> commit 71a77e07d0e33b57d4a50c173e5ce4fabceddbec
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Wed Feb 2 12:13:49 2011 +0000
> 
>     drm/i915: Invalidate TLB caches on SNB BLT/BSD rings
> 
> I hope one of these brings stability back to your machine...
> -Chris
> 

Alas, neither of those patches seems to help.

-- 
Bobby Bingham
このメールは再利用されたバイトでできている。
