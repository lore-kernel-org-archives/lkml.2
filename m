Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1HEJvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:51:43 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:35518 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1HEJvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:51:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tykT0Y6ehRJ-=oOj-SGbS8TyrXQzS2iTDZ1Ukf4-LES1Q@mail.gmail.com>
References: <alpine.DEB.2.00.1108051019200.14655@skynet.skynet.ie>
	<CAOJsxLHAQGNWN8-jnAFh=bOXqEZbXQsBucqETOSwoCXbuL9wBw@mail.gmail.com>
	<CAPM=9tykT0Y6ehRJ-=oOj-SGbS8TyrXQzS2iTDZ1Ukf4-LES1Q@mail.gmail.com>
Date: Fri, 5 Aug 2011 12:51:42 +0300
X-Google-Sender-Auth: iBLTqMP9xJP27arJQFlEZcEtnRk
Message-ID: <CAOJsxLF+QposjZjPcPMQMfQ9Z0Fj_uZMU2c9miF_HDqYdejhzQ@mail.gmail.com>
Subject: Re: [git pull drm fixes
From: Pekka Enberg <penberg@kernel.org>
To: Dave Airlie <airlied@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Francesco Allertsen <fallertsen@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 12:48 PM, Dave Airlie <airlied@gmail.com> wrote:
>> Isn't "drm/i915: Try enabling RC6 by default (again)" still broken for
>> some people? Keith, Francesco? If Linus pulls now, we end up with
>> broken i915 in -rc1 once again, no?
>
> I think we are trying again with RC6, if it doesn't work this time,
> it'll get reverted before release. Its really a useful feature and the
> more testing of it the Intel guys can get the quicker they seem to be
> able to make it more likely to be the default.

Please don't do that! The RC6 patch is known to be broken for at least
one configuration:

https://patchwork.kernel.org/patch/1033782/

See the last email from Francesco. I don't know why you insist pushing
patches that are known to be fragile in the past without getting broad
Tested-by tags from people who have been affected in the past.

                       Pekka
