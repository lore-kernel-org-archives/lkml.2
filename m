Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab1IHIDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:03:44 -0400
Received: from mail-qw0-f45.google.com ([209.85.216.45]:46356 "EHLO
	mail-qw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab1IHIDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:03:41 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Sep 2011 04:03:41 EDT
MIME-Version: 1.0
In-Reply-To: <CAJJYPd=g9LYqH3OCVA674=aTF2qJSZHzgqBck1nJ_WpqVV4iAw@mail.gmail.com>
References: <CAJJYPd=g9LYqH3OCVA674=aTF2qJSZHzgqBck1nJ_WpqVV4iAw@mail.gmail.com>
Date: Thu, 8 Sep 2011 14:57:42 +0700
Message-ID: <CA+i8gKKzZUYSGwStPQFJe8YergSXLnn=xj3Odt4rVyQ5Ou+n_w@mail.gmail.com>
Subject: Re: kernel BUG at drivers/gpu/drm/i915/i915_gem.c:3459
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, keithp@keithp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 3:50 AM, Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
> This happened to today probably in the moment, LCD was turned off by
> Xserver as a screenblank

Maybe related as both issues seem to be triggered by the same event:
http://lkml.org/lkml/2011/9/7/182
