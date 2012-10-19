Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab2JSV0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:26:21 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37880 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2JSV0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:26:20 -0400
MIME-Version: 1.0
In-Reply-To: <1724445.dN2yMEzN6d@localhost>
References: <1724445.dN2yMEzN6d@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Oct 2012 14:25:59 -0700
X-Google-Sender-Auth: Bn5hc3L0AfATWcDgdPdFiFya5Bo
Message-ID: <CA+55aFy8Te9VFaZRZSDYMehbfg-qLDBYv6=EKncQ2=J2XaF+Vg@mail.gmail.com>
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
To: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pawel.sikora@agmk.net>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Martin Peres <martin.peres@labri.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added more appropriate people to this. Added both i915 and nouveau
people, since apparently that fine piece of hardware has both.

Guys, any ideas?

Paweł, could you perhaps get a photo of the oops and post it
somewhere? I'm assuming the oops happens early during boot and you
never get a usable machine with dmesg - but if you do, then please do
post the whole dmesg too.

              Linus

On Thu, Oct 18, 2012 at 12:32 AM, Paweł Sikora <pawel.sikora@agmk.net> wrote:
> Hi,
>
> the new 3.7.0-rc1-00078-g8d2b6b3 kernel oopses during startup on my asus laptop
> with nvidia optimius crap and the builtin core-i7 graphics doesn't start.
> the 3.5/3.6 kernels work fine, so this looks like a fresh regression.
>
> BR,
> Paweł.
