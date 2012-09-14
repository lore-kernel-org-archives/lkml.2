Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2INNKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:10:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54592 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab2INNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:10:03 -0400
MIME-Version: 1.0
In-Reply-To: <84c8a8$5o3dgr@orsmga001.jf.intel.com>
References: <1347627426-3813-1-git-send-email-grant.likely@secretlab.ca> <84c8a8$5o3dgr@orsmga001.jf.intel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Sep 2012 14:09:43 +0100
X-Google-Sender-Auth: IJAeHcL6br_snFNka0Yvv9cBF0E
Message-ID: <CACxGe6u0+LC4G-87PsEK3ys7qqeJ2WnqnCdaegMK7=M9xpA8ug@mail.gmail.com>
Subject: Re: [PATCH] i915: Quirk out disconnected backlight
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 2:01 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Fri, 14 Sep 2012 13:57:06 +0100, Grant Likely <grant.likely@secretlab.ca> wrote:
>> Some platforms (for instance MacbookPros) have custom backlight drivers
>> and don't use the integrated i915 backlight control. This patch adds a
>> quirk to disable registering the intel backlight when unused on a
>> platform.
>>
>> Tested on MacbookPro8,3. Without this patch both the intel_backlight and
>> gmux_backlight devices get registered and userspace doesn't know which
>> it should use.
>
> Userspace is informed throught the backlight/type property.

Perhaps, but userspace (Ubuntu) isn't doing anything with it, and it
still remains that it makes no sense whatsoever to register a
backlight device that doesn't exist.

g.

> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
