Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1GLTfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:35:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107Ab1GLTfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:35:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110712181536.GA30364@redhat.com>
References: <20110712181536.GA30364@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Jul 2011 12:34:49 -0700
Message-ID: <CA+55aFx+dyu54VYU7_Bc=3D3hsEdH2SLb6DV2w+5eiQH9Zo41w@mail.gmail.com>
Subject: Re: drm_lock()->block_all_signals() is broken
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 11:15 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I tried many times to ask about the supposed behaviour of
> block_all_signals() in drm, but it seems nobody can answer.

It's always been broken, I think. We've had threads about it before
(years and years ago). I'd certainly be willing to just remove it
entirely, and see if anything pops up that ends up actually working
and being saner.

                   Linus
