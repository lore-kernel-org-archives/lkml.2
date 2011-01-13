Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab1AMA2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:28:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756402Ab1AMA2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:28:09 -0500
MIME-Version: 1.0
In-Reply-To: <1294877597-17843-1-git-send-email-chris@chris-wilson.co.uk>
References: <1294877597-17843-1-git-send-email-chris@chris-wilson.co.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Jan 2011 16:27:46 -0800
Message-ID: <AANLkTi=qHW3esgZYq55dgSz15ZDpukXn6zO17nJ1fWzS@mail.gmail.com>
Subject: Re: [PATCH] drm/i915/execbuffer: Reorder relocations to match new
 object order
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 4:13 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> This is what I'm running with at the moment. It only appears to affect the
> slow path which hopefully explains why it is relatively infrequent...

I think you're still missing some case.

This improves the video case a lot - I can't see any artifacts there -
but I still get occasional corruption when moving between the "share"
and "rate" buttons, and they end up drawing incorrectly.

So you're close. But no cigar.

                          Linus
