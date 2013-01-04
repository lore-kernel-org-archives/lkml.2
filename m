Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3ADO6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:58:55 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:34247 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab3ADO6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:58:54 -0500
MIME-Version: 1.0
In-Reply-To: <1357299595-16037-1-git-send-email-chris@chris-wilson.co.uk>
References: <CAB9v_DE0qMdQ2poxv++FGd2zo+Tw5_m6kgTOoBZSCUOGZf+fNA@mail.gmail.com>
 <1357299595-16037-1-git-send-email-chris@chris-wilson.co.uk>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Date: Fri, 4 Jan 2013 16:58:33 +0200
Message-ID: <CAB9v_DGySBY7Vq1MY=cpU5Thse9FgOQZ8ShggLnMiTmwSS7G=A@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Treat crtc->mode.clock == 0 as disabled
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 1:39 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> Prevent a divide-by-zero by consistently treating an 'active' CRTC
> without a mode set as actually disabled.
> ---

Works fine here, thanks.
