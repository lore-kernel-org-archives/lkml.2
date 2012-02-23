Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2BWR3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:29:30 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61696 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab2BWR31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:29:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.79.229 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <aefc95$3a3h8b@orsmga001.jf.intel.com>
References: <4F4669B1.4020306@tu-ilmenau.de> <aefc95$3a3h8b@orsmga001.jf.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 09:29:06 -0800
X-Google-Sender-Auth: ZsiqJZcpnZjHiCqZalIH4c9YsgQ
Message-ID: <CA+55aFwDXZSwDf3xjAofe_R15pu5G0Pg2UnkJTx-KVTXez4ZqA@mail.gmail.com>
Subject: Re: responsiveness: newer kernels causing lagging and blocking
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stephan.baerwolf@tu-ilmenau.de, linux-kernel@vger.kernel.org,
        Michael Buesch <mb@bu3sch.de>, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 9:21 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> One mystery that has never been resolved is just why wine causes a flood
> of xrandr/connection probes, and then there is still the underlying issue
> that probing blocks the device and causes noticeable latency.

Is there any chance that the EDID code would just have a "if I probed
in the last second or two, let's not do it again and instead just
return the cached data from last time" thing to just protect against
some odd interrupt flood (or a user that asks for edid information
explicitly like xrandr).

                   Linus
