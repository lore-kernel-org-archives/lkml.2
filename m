Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1HHSux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:50:53 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:45817 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750868Ab1HHSuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:50:52 -0400
Date: Mon, 8 Aug 2011 11:50:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 1/4] drm/i915: Wait for LVDS panel power
 sequence
Message-ID: <20110808115039.75384477@jbarnes-desktop>
In-Reply-To: <yunty9ru4qh.fsf@aiko.keithp.com>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com>
	<1312653248-3487-2-git-send-email-keithp@keithp.com>
	<20110808092719.4f62983d@jbarnes-desktop>
	<yunty9ru4qh.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Aug 2011 11:40:06 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Mon, 8 Aug 2011 09:27:19 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > ...to catch places like this where the wrong register gets used. :)
> 
> Ouch! There are only two places we *should* have these loops, one when
> turning it off, another when turning it on. There's a couple of loops
> which just need to be removed.
> 

Yeah looks better.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
