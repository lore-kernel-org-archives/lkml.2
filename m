Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2IQQC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:02:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56869 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab2IQQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:02:25 -0400
MIME-Version: 1.0
In-Reply-To: <87a9wp84a5.fsf@intel.com>
References: <1347627426-3813-1-git-send-email-grant.likely@secretlab.ca>
 <84c8a8$5o3dgr@orsmga001.jf.intel.com> <CACxGe6u0+LC4G-87PsEK3ys7qqeJ2WnqnCdaegMK7=M9xpA8ug@mail.gmail.com>
 <1347628339.21322.16.camel@shinybook.infradead.org> <CACxGe6szLVwsdNOvpB9v8pGDrygu+Go5Vf3bvpE19v3+Hkv4ww@mail.gmail.com>
 <87a9wp84a5.fsf@intel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 17 Sep 2012 17:02:03 +0100
X-Google-Sender-Auth: qQwaZOy930vWh3lrqeB5uVRHawY
Message-ID: <CACxGe6sFibn9b+oMWTFbYEno8xJvw6S2d8RM9juaCHPStaSnOQ@mail.gmail.com>
Subject: Re: [PATCH] i915: Quirk out disconnected backlight
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 9:03 AM, Jani Nikula
<jani.nikula@linux.intel.com> wrote:
> Hi Grant, please try v3.6-rc6 that does exactly that with:
>
> commit 28dcc2d60cb570d9f549c329b2f51400553412a1
> Author: Jani Nikula <jani.nikula@intel.com>
> Date:   Mon Sep 3 16:25:12 2012 +0300
>
>     drm/i915: do not expose a dysfunctional backlight interface to userspace
>
> Does that fix it for you?

Yes, thanks.

g.
