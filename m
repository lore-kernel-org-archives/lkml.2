Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1HEJpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:45:40 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:42517 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab1HEJpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:45:35 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1108051019200.14655@skynet.skynet.ie>
References: <alpine.DEB.2.00.1108051019200.14655@skynet.skynet.ie>
Date: Fri, 5 Aug 2011 12:45:35 +0300
X-Google-Sender-Auth: sqVjbkcHNEWWd4rQyiSqJ5BTBc4
Message-ID: <CAOJsxLHAQGNWN8-jnAFh=bOXqEZbXQsBucqETOSwoCXbuL9wBw@mail.gmail.com>
Subject: Re: [git pull drm fixes
From: Pekka Enberg <penberg@kernel.org>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Keith Packard <keithp@keithp.com>,
        Francesco Allertsen <fallertsen@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Fri, Aug 5, 2011 at 12:22 PM, Dave Airlie <airlied@linux.ie> wrote:
> Intel modesetting fixes a lot of them, Keith, Jesse and ajax have been
> focusing on a lot of the corner cases and display port and hdmi stuff.
>
> misc radeon fixes, the main one being for certain machines where EDID
> returns what looks like misc noise when connectors aren't populated on
> certain boards.
>
> and some misc trivial type fixes.

Isn't "drm/i915: Try enabling RC6 by default (again)" still broken for
some people? Keith, Francesco? If Linus pulls now, we end up with
broken i915 in -rc1 once again, no?

                         Pekka
