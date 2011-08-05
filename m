Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1HEJsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:48:46 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:60167 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1HEJsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:48:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLHAQGNWN8-jnAFh=bOXqEZbXQsBucqETOSwoCXbuL9wBw@mail.gmail.com>
References: <alpine.DEB.2.00.1108051019200.14655@skynet.skynet.ie>
	<CAOJsxLHAQGNWN8-jnAFh=bOXqEZbXQsBucqETOSwoCXbuL9wBw@mail.gmail.com>
Date: Fri, 5 Aug 2011 10:48:42 +0100
Message-ID: <CAPM=9tykT0Y6ehRJ-=oOj-SGbS8TyrXQzS2iTDZ1Ukf4-LES1Q@mail.gmail.com>
Subject: Re: [git pull drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Francesco Allertsen <fallertsen@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 10:45 AM, Pekka Enberg <penberg@kernel.org> wrote:
> Hi Dave,
>
> On Fri, Aug 5, 2011 at 12:22 PM, Dave Airlie <airlied@linux.ie> wrote:
>> Intel modesetting fixes a lot of them, Keith, Jesse and ajax have been
>> focusing on a lot of the corner cases and display port and hdmi stuff.
>>
>> misc radeon fixes, the main one being for certain machines where EDID
>> returns what looks like misc noise when connectors aren't populated on
>> certain boards.
>>
>> and some misc trivial type fixes.
>
> Isn't "drm/i915: Try enabling RC6 by default (again)" still broken for
> some people? Keith, Francesco? If Linus pulls now, we end up with
> broken i915 in -rc1 once again, no?

I think we are trying again with RC6, if it doesn't work this time,
it'll get reverted before release. Its really a useful feature and the
more testing of it the Intel guys can get the quicker they seem to be
able to make it more likely to be the default.

Dave.
