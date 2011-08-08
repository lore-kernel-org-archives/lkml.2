Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1HHQaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:30:24 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44129 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752996Ab1HHQaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:30:23 -0400
Date: Mon, 8 Aug 2011 09:30:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/4] drm/i915: Leave LVDS registers unlocked
Message-ID: <20110808093010.487c4559@jbarnes-desktop>
In-Reply-To: <1312653248-3487-3-git-send-email-keithp@keithp.com>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com>
	<1312653248-3487-3-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  6 Aug 2011 10:54:06 -0700
Keith Packard <keithp@keithp.com> wrote:

> There's no reason to relock them; it just makes operations more
> complex. This fixes DPMS where the panel registers were locked making
> the disable not work.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

Yep, looks fine.  The only think we might want to sprinkle about are
checks for panel off so we can avoid visible corruption if we whack
timing or fb stuff while the panel is on.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
