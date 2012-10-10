Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab2JJVuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 17:50:02 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63361 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab2JJVt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 17:49:59 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAKMK7uFsYUYuvWu2tWNc6+soPJpsJt6pz-A5EePc9oF7fG6uAA@mail.gmail.com>
References: <CAHFgRy9vSEwBe34VffBWZgy6ik_O0_FHW+fwasnN643WQX8gCg@mail.gmail.com>
	<CAKMK7uFsYUYuvWu2tWNc6+soPJpsJt6pz-A5EePc9oF7fG6uAA@mail.gmail.com>
Date: Wed, 10 Oct 2012 23:49:58 +0200
Message-ID: <CAKMK7uEQ2+45wg_n9PKEaOyvOJ=HrSYn2=4dNGBODvNidn9FEQ@mail.gmail.com>
Subject: Re: 3.6.0+ (GIT) -- WARNING: at drivers/gpu/drm/i915/intel_display.c:1271
 intel_disable_pipe+0xab/0x12e() -- plane B assertion failure, should be off
 on pipe B but is still active
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 4:56 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> This should help: https://patchwork.kernel.org/patch/1436231/
>
> It's not merged yet since it cause a black screen on resume on one of
> my really old machines. Issue isn't new at all, but the new modeset
> code is _much_ more anal about cross-checking the hw state with what
> we expect to be there.

I think I've tracked down the gen2 issue I've seen, so the above
linked patch can go in. Does it get rid of the WARN backtraces on your
machine? A tested-by would be most welcome ...

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
