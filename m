Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571Ab0I0UJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:09:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933483Ab0I0UJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:09:08 -0400
Date: Mon, 27 Sep 2010 13:08:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matt Mackall <mpm@selenic.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm: Prune GEM vma entries
Message-Id: <20100927130844.b57ee9eb.akpm@linux-foundation.org>
In-Reply-To: <1285618116-10086-1-git-send-email-chris@chris-wilson.co.uk>
References: <20100927115207.633024b1.akpm@linux-foundation.org>
	<1285618116-10086-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That was quick, thanks.

On Mon, 27 Sep 2010 21:08:36 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> Hook the GEM vm open/close ops into the generic drm vm open/close so
> that the vma entries are created and destroy appropriately.

Please update the changelog to indicate that it fixes a memory leak.

> Reported-by: Matt Mackall <mpm@selenic.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

And here please add

Cc: <stable@kernel.org>

so that earlier kernels get reliably fixed.

Thanks.


