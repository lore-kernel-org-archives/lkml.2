Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3ACVc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 16:32:28 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44736 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3ACVc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 16:32:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAB9v_DHJYAEcZDuPd3XBEib_nGca=_sKbZngV3z1N6H8KcJJGQ@mail.gmail.com>
References: <CA+55aFxQ9vH70UrqC0ypm-diNbGcZbWbdhYa3FLH+0Vbrk4hUQ@mail.gmail.com>
 <CAB9v_DHJYAEcZDuPd3XBEib_nGca=_sKbZngV3z1N6H8KcJJGQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Jan 2013 13:32:04 -0800
X-Google-Sender-Auth: y1CCNQWcYX-L4O-wWk1xRMpzlxg
Message-ID: <CA+55aFzQtxET9JWdaLGi52OL=A9yRbj+vaa7RfniuBvfB5K04Q@mail.gmail.com>
Subject: Re: Linux 3.8-rc2
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 1:09 PM, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>
> i915 got broken on my machine (Lenovo ThinkPad SL500) by this -rc. The screen
> goes blank after loading the module. I've bisected the problem to
> b0a2658acb5bf9ca86b4aab011b7106de3af0add "drm/i915: don't disable
> disconnected outputs".

Hmm. Daniel - should I just revert it, or do you have a patch to
possibly fix the divide-by-zero error in g4x_compute_wm0() (which may
involve not getting that deep in the call chain to begin with or
whatever)? Maybe that fixes the blank screen too without a revert..

                 Linus
