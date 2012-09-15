Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2IOM4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 08:56:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46937 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab2IOM4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 08:56:50 -0400
MIME-Version: 1.0
In-Reply-To: <1347644982-17386-2-git-send-email-Dmitrii.Cherkasov@amd.com>
References: <1347644982-17386-1-git-send-email-Dmitrii.Cherkasov@amd.com>
	<1347644982-17386-2-git-send-email-Dmitrii.Cherkasov@amd.com>
Date: Sat, 15 Sep 2012 14:56:49 +0200
Message-ID: <CAGZ4FESdyqFbMxJir=QdRURU1J-03NLOr+XT-TzqHFf+S=J8WQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add 2-level GPUVM pagetables support to radeon
 driver. v2
From: Maarten Maathuis <madman2003@gmail.com>
To: Dmitry Cherkasov <dcherkassov@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 7:49 PM, Dmitry Cherkasov <dcherkassov@gmail.com> wrote:
> +#define RADEON_PT_OFFSET(_rdev) \
> +       (RADEON_GPU_PAGE_ALIGN(RADEON_TOTAL_PDE_COUNT(rdev) * RADEON_PDE_SIZE))

Shouldn't that be _rdev too?

Also a few lines above that you use rdev instead of _rdev.

I didn't check the whole thing, just noticed that when i was staring
at it for no reason :-)

-- 
Far away from the primal instinct, the song seems to fade away, the
river get wider between your thoughts and the things we do and say.
