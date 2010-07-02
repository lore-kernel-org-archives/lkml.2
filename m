Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0GBBjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 21:39:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497Ab0GBBjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 21:39:36 -0400
MIME-Version: 1.0
In-Reply-To: <20100702003758.GA15055@kroah.com>
References: <1278029082-24223-1-git-send-email-airlied@gmail.com>
	<20100702003758.GA15055@kroah.com>
Date: Thu, 1 Jul 2010 18:39:19 -0700
Message-ID: <AANLkTinADjOyToI-7uODQkCrnN1Xh6u8EfYzGce4anSB@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: fix hibernation since 4bdadb9785696439c6e2b3efe34aa76df1149c83
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Dave Airlie <airlied@gmail.com>, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 5:37 PM, Greg KH <greg@kroah.com> wrote:
>
> This should go into .33 and .34-stable trees, right?

Yup. I added a "cc: stable" to the patch, and it's now commit
985b823b919 in my tree, you'll see it when I push it out along with
the other dri updates.

              Linus
