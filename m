Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2K0Wry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:47:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51706 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2K0Wrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:47:53 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAAHQ8EFQVxvUR3SAiBZOiK2W_WQ6Ui=UgTTq+zfY8mjfhfpEBg@mail.gmail.com>
References: <CAAHQ8EFQVxvUR3SAiBZOiK2W_WQ6Ui=UgTTq+zfY8mjfhfpEBg@mail.gmail.com>
Date: Tue, 27 Nov 2012 23:47:51 +0100
Message-ID: <CAKMK7uH0u60DtGYjFYqF4+D0tPycv4zyDSg+HBS54YnOrRaYUQ@mail.gmail.com>
Subject: Re: Your kernel commit 2f4f649a69a9eb51f6e98130e19dd90a260a4145
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Magnus R <marasgp@gmail.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 10:58 PM, Magnus R <marasgp@gmail.com> wrote:
> I run the 3.7 release candidates on my retina Macbook Pro and starting with
> rc6 the graphics have become garbled. I have narrowed it down to your above
> mentioned commit in drivers/gpu/drm/i915/intel_display.c (when I revert that
> commit the graphics is not garbled). Please point me in the right direction
> if you would like me to file bug in a more systematic manner, or let me know
> if I can assist with any data of my configuration.

Should be fixed with 9a30a61f3516871c5c638f from the drm-intel-fixes
tree from http://cgit.freedesktop.org/~danvet/drm-intel The pull
request for that is currently pending with Dave Airlie.

Cheers, Daniel

PS: When reporting regressions, please always include relevant mailing
list, so that other people see them to (and maybe also because your
dear maintainer may miss a mail every once a while ...).
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
